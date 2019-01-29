import base64
import json
import os
import re
import ssl
import sys
from binascii import b2a_hex, a2b_hex

import click
import requests
from cryptography.fernet import Fernet
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.ec import EllipticCurvePublicKey, EllipticCurvePrivateKey
from cryptography.hazmat.primitives.serialization import load_pem_private_key, load_pem_public_key
from paho.mqtt import client as paho
from tinydb import TinyDB, where, Query
from passlib.hash import bcrypt


sys.stdout = open(os.devnull, 'w')
sys.path.insert(0, '../app')
from app.api.utils import is_number
from app.utils import bytes_to_json
sys.stdout = sys.__stdout__

try:  # for packaged CLI (setup.py)
    from client.crypto_utils import hash, correctness_hash, check_correctness_hash, int_to_bytes, instantiate_ope_cipher, int_from_bytes
    from client.utils import json_string_with_bytes_to_dict, _create_payload
except ImportError:  # for un-packaged CLI
    from crypto_utils import hash, correctness_hash, check_correctness_hash, instantiate_ope_cipher, int_from_bytes
    from utils import json_string_with_bytes_to_dict, _create_payload


URL_BASE = "https://localhost/api/"
URL_PUBLISH = URL_BASE + "publish"
URL_CREATE_DEVICE_TYPE = URL_BASE + "device_type/create"
URL_CREATE_DEVICE = URL_BASE + "device/create"
URL_GET_DEVICE = URL_BASE + "device/get"
URL_GET_DEVICE_DATA_BY_RANGE = URL_BASE + "data/get_time_range"
URL_GET_DEVICE_DATA = URL_BASE + "data/get_device_data"
URL_START_KEY_EXCHANGE = URL_BASE + "exchange_session_keys"
URL_RECEIVE_PUBLIC_KEY = URL_BASE + "retrieve_public_key"

AA_URL_BASE = "https://localhost/attr_auth/"
AA_URL_SET_USERNAME = AA_URL_BASE + "set_username"
AA_URL_SETUP = AA_URL_BASE + "setup"
AA_URL_KEYGEN = AA_URL_BASE + "keygen"
AA_URL_ENCRYPT = AA_URL_BASE + "encrypt"
AA_URL_DECRYPT = AA_URL_BASE + "decrypt"

dir_path = os.path.dirname(os.path.realpath(__file__))
path = f'{dir_path}/keystore.json'


@click.group()
@click.pass_context
def user(ctx):
    global VERIFY_CERTS
    global MQTT_BROKER
    global MQTT_PORT
    VERIFY_CERTS = ctx.obj['VERIFY_CERTS']
    MQTT_BROKER = ctx.obj['BROKER']
    MQTT_PORT = ctx.obj['PORT']


@user.command()
@click.argument('device_id')
@click.argument('data')
def send_message(device_id, data):
    db = TinyDB(path)
    table = db.table(name='device_keys')
    doc = table.get(Query().device_id == device_id)

    if not doc:
        with click.Context(send_key_to_device) as ctx:
            click.echo(f"Keys for device {device_id} not present, please use: {ctx.command.name}")
            click.echo(get_attr_auth_keys.get_help(ctx))
            return

    shared_key = a2b_hex(doc["shared_key"].encode())
    fernet_key = Fernet(base64.urlsafe_b64encode(shared_key))
    token = fernet_key.encrypt(data.encode())

    client = _setup_client("user_id")  # TODO replace with actual user_id

    payload = _create_payload(1, {"ciphertext": token.decode()})
    ret = client.publish(f"1/{device_id}", payload)  # TODO replace with actual user_id, change payload to json and parse it as JSON on device end
    click.echo(f"RC and MID = {ret}")


@user.command()
@click.argument('description')
@click.option('--token', envvar='ACCESS_TOKEN')
def create_device_type(description, token):
    data = {"description": description, "access_token": token, "correctness_hash": correctness_hash(description)}
    r = requests.post(URL_CREATE_DEVICE_TYPE, params=data, verify=VERIFY_CERTS)
    click.echo(r.content.decode('unicode-escape'))


@user.command()
@click.argument('device_type_id')
@click.argument('device_name')
@click.argument('user_id')
@click.option('--token', envvar='ACCESS_TOKEN')
def create_device(device_type_id, user_id, device_name, token):
    data = {
        "type_id": device_type_id,
        "access_token": token,
        "name": device_name,
        "correctness_hash": correctness_hash(device_name),
        "name_bi": hash(device_name, user_id)}
    r = requests.post(URL_CREATE_DEVICE, params=data, verify=VERIFY_CERTS)
    click.echo(r.content.decode('unicode-escape'))


@user.command()
@click.argument('device_name')
@click.argument('user_id')
@click.option('--token', envvar='ACCESS_TOKEN')
def get_devices(device_name, user_id, token):
    device_name_bi = hash(device_name, user_id)
    data = {"name_bi": device_name_bi, "access_token": token}
    r = requests.post(URL_GET_DEVICE, params=data, verify=VERIFY_CERTS)
    content = json.loads(r.content.decode('unicode-escape'))
    check_correctness_hash(content["devices"], "name")
    click.echo(content["devices"])


@user.command()
@click.option('--lower', required=False)
@click.option('--upper', required=False)
@click.option('--token', envvar='ACCESS_TOKEN')
def get_device_data_by_time_range(lower=None, upper=None, token=""):  # TODO add decryption based on stored keys
    if lower is not None and upper is not None:
        data = {"lower": int(lower), "upper": int(upper), "access_token": token}
    elif lower is not None and upper is None:
        data = {"lower": int(lower), "access_token": token}
    elif lower is None and upper is not None:
        data = {"upper": int(upper), "access_token": token}
    else:
        data = {"lower": 0, "upper": 2147483647, "access_token": token}
    r = requests.post(URL_GET_DEVICE_DATA_BY_RANGE, params=data, verify=VERIFY_CERTS)
    content = r.content.decode('unicode-escape')
    json_content = json_string_with_bytes_to_dict(content)
    check_correctness_hash(json_content["device_data"], 'added', 'data', 'num_data')  # TODO add TID and update test and schema with correctness hashes that include TID
    click.echo(content)


@user.command()
@click.argument('device_id')
@click.option('--token', envvar='ACCESS_TOKEN')
def send_key_to_device(device_id, token):
    private_key = ec.generate_private_key(ec.SECP384R1(), default_backend())
    public_key = private_key.public_key()
    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    ).decode('utf-8')

    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=serialization.NoEncryption()
    ).decode()
    db = TinyDB(path)
    table = db.table(name='device_keys')
    table.upsert({
        'device_id': device_id,
        'public_key': public_pem,
        'private_key': private_pem
    }, Query().device_id == device_id)

    data = {
        'device_id': device_id,
        'public_key': public_pem,
        'access_token': token
    }
    r = requests.post(URL_START_KEY_EXCHANGE, params=data, verify=VERIFY_CERTS)
    click.echo(r.content.decode('unicode-escape'))


@user.command()
@click.argument('device_id')
@click.option('--token', envvar='ACCESS_TOKEN')
def retrieve_device_public_key(device_id, token):
    data = {
        "access_token": token,
        "device_id": device_id
    }
    db = TinyDB(path)
    table = db.table(name='device_keys')
    doc = table.get(Query().device_id == device_id)

    if not doc:
        with click.Context(send_key_to_device) as ctx:
            click.echo(f"Keys for device {device_id} not present, please use: {ctx.command.name}")
            click.echo(get_attr_auth_keys.get_help(ctx))
            return

    r = requests.post(URL_RECEIVE_PUBLIC_KEY, params=data, verify=VERIFY_CERTS)
    if r.status_code != 200:
        click.echo(r.content.decode('unicode-escape'))
        return

    content = r.content.decode('unicode-escape')
    json_content = json_string_with_bytes_to_dict(content)

    private_key = load_pem_private_key(doc["private_key"].encode(), password=None, backend=default_backend())
    assert isinstance(private_key, EllipticCurvePrivateKey), "Loading private key failed! - private_key is not instance of EllipticCurvePrivateKey"
    device_public_key = load_pem_public_key(json_content["device_public_key"].encode(), backend=default_backend())
    assert isinstance(device_public_key, EllipticCurvePublicKey), "Loading public key failed! - private_key is not instance of EllipticCurvePublicKey"
    shared_key = private_key.exchange(ec.ECDH(), device_public_key)

    key = b2a_hex(shared_key[:32]).decode()  # NOTE: retrieve key as `a2b_hex(key.encode())`
    table.remove(Query().device_id == device_id)
    table.insert({'device_id': device_id, 'shared_key': key})


@user.command()
@click.argument('device_id')
def send_column_keys(device_id):
    db = TinyDB(path)
    table = db.table(name='device_keys')
    doc = table.get(Query().device_id == device_id)

    if not doc:
        with click.Context(send_key_to_device) as ctx:
            click.echo(f"Keys for device {device_id} not present, please use: {ctx.command.name}")
            click.echo(get_attr_auth_keys.get_help(ctx))
            return

    shared_key = a2b_hex(doc["shared_key"].encode())
    fernet_key = Fernet(base64.urlsafe_b64encode(shared_key))

    keys = {
        "action:name": None,
        "device_type:description": None,
        "device:name": None,
        "device:status": None,
        "device_data:added": None,
        "device_data:num_data": None,
        "device_data:data": None,
        "scene:name": None,
        "scene:description": None
    }

    payload_keys = {}
    for k in keys:
        random_bytes = os.urandom(32)
        keys[k] = b2a_hex(random_bytes).decode()  # NOTE: retrieve key as `a2b_hex(key.encode())`
        payload_keys[k] = fernet_key.encrypt(random_bytes).decode()

    doc = {**doc, **keys}
    table.update(doc)

    client = _setup_client("user_id")  # TODO replace with actual user_id
    payload = _create_payload(1, payload_keys)
    ret = client.publish(f"1/{device_id}", payload)  # TODO replace with actual user_id
    click.echo(f"RC and MID = {ret}")


fake_tuple_data = None


@user.command()
@click.argument('device_id')
@click.option('--token', envvar='ACCESS_TOKEN')
def get_device_data(device_id, token):  # TODO right now it requires device to 1st use `get_fake_tuple` (`init_integrity_data`) before 1st call to this
    """
    Queries server for data of :param device_id device and then verifies the received data using
    integrity information from device (received using MQTT Broker) and correctness hash attribute
    of each DB row.
    """
    user_id = 1  # TODO get it from env_var or file
    data = {"device_id": device_id, "access_token": token}

    r = requests.post(URL_GET_DEVICE_DATA, params=data, verify=VERIFY_CERTS)
    content = r.content.decode('unicode-escape')
    click.echo("Tu je response:")
    click.echo(r.content)
    json_content = json_string_with_bytes_to_dict(content)

    click.echo("Tu su data:")
    click.echo(json_content["device_data"])
    _get_fake_tuple_data(user_id, int(device_id))
    click.echo("Tu su integrity info:")
    click.echo(fake_tuple_data)
    fake_tuples, rows = _divide_fake_and_real_data(json_content["device_data"], device_id, fake_tuple_data)
    click.echo("Tu su fake_tuples:")
    click.echo(fake_tuples)
    click.echo("Tu su rows:")
    click.echo(rows)
    verify_integrity_data(generate_fake_tuples_in_range(fake_tuple_data), fake_tuples)

    check_correctness_hash(rows, 'added', 'data', 'num_data')  # TODO add TID and update test and schema with correctness hashes that include TID (is_fake already uses TID)
    click.echo(json_content["device_data"])
    click.echo(fake_tuple_data)


def _handle_on_message(mqtt_client, userdata, msg, device_id, user_id):
    msg.payload = bytes_to_json(msg.payload)  # TODO sanitize this?
    topic = msg.topic.split("/")
    if is_number(topic[0]) and int(topic[0]) == device_id and is_number(topic[1]) and int(topic[1]) == user_id:
        mqtt_client.disconnect()
        global fake_tuple_data
        fake_tuple_data = msg.payload


def _get_fake_tuple_data(user_id, device_id):
    payload_dict = {"request": "fake_tuple_info"}

    def on_message(mqtt_client, userdata, msg):
        _handle_on_message(mqtt_client, userdata, msg, device_id, user_id)

    client = _setup_client(str({user_id}))
    payload = _create_payload(user_id, payload_dict)
    client.subscribe(f"{device_id}/{user_id}")
    client.publish(f"{user_id}/{device_id}", payload)
    client.on_message = on_message
    click.echo("Waiting for response, CTRL-C to terminate...")
    client.loop_forever()


def _divide_fake_and_real_data(rows, device_id, integrity_info):
    """ Split data into 2 lists based on 'fakeness'
    Decrypts each row and computes fake correctness hash, then tests (using bcrypt)
    whether `correctness_hash` of row is 'same' as computed fake correctness hash
    :param device_id
    :param rows: example: [{
        'added': 37123,
        'correctness_hash': '$2b$12$FSuBaNwezizWJcj47RxYJOpur2k49IJObfIPLDce5pKpRRZEASt6m',
        'data': 'gAAAAABcUECMQMM0MjKknugGdI6YN81pLtmLUrcMsjHMBG87KpIJFWZF8n1DTVJX7VvnlVMMN4BNGdVROLeCD_I0XUs0IAK9AA==',
        'device_id': 23,
        'id': 1,
        'num_data': -9199,
        'tid': 3}, ...]
    """
    db_col_names = ["device_data:added", "device_data:data", "device_data:num_data"]
    enc_keys = get_encryption_keys(device_id, db_col_names)
    col_types = {col: get_col_encryption_type(col, integrity_info) for col in db_col_names}
    key_type_pairs = {}
    for k, v in enc_keys.items():
        key_type_pairs[k.split(":")[1]] = [enc_keys[k], col_types[k]]

    real, fake = [], []
    for row in rows:
        modified = row
        modified.pop("id")
        modified.pop("device_id")
        row_correctness_hash = modified.pop("correctness_hash")
        decrypted = decrypt_row(modified, key_type_pairs)
        row_values = [decrypted["added"], decrypted["num_data"], decrypted["data"], decrypted["tid"]]
        if is_fake(row_values, row_correctness_hash):
            fake.append(decrypted)
        else:
            real.append(decrypted)

    return fake, real


def get_encryption_keys(device_id, db_keys):
    """
    Retrieves encryption (decryption) keys corresponding to :param db_keys from TinyDB file
    :param device_id
    :param db_keys: list of TinyDB key names, e.g.: ["device_type:description", "action:name"]
    :return: dictionary of key, value pair of column name and encryption string, e.g.: {"action:name": "9dd1a57836a5...858372a8c0c42515", ...}
    """
    db = TinyDB(path)
    table = db.table(name='device_keys')
    doc = table.get(Query().device_id == device_id)
    result = {}
    for key in db_keys:
        result[key] = doc[key]
    return result


def get_col_encryption_type(col_name, integrity_info):
    """
    Returns True or False based on whether the column is encrypted as number (OPE) or not (Fernet) - this
    is based on "is_numeric" attribute in TinyDB
    :param integrity_info: {
            'device_data': {
                'added': {
                    'function_name': 'triangle_wave',
                    'lower_bound': 1,
                    'upper_bound': 1,
                    'is_numeric': True
                    }}}
    :param col_name: e.g. "device_data:data"
    :return:
    """
    table, col = col_name.split(":")
    return integrity_info[table][col]["is_numeric"]


def decrypt_row(row, keys):
    """
    :param row: example: {
        "added": 36976,
        "num_data": -9272,
        "data": "gAAAAABcTyUFZrhQRLzLvwep7j0Vm2UFjS2ylZ7bjB2YRueDpX15tobA0oOSEWBYZ4LaCKRa_h7WyKMacAAt-982srPPOR_1Cw==",
        "tid": 1
    }
    :param keys: example:
        "added": ["26751017213ff85f189bedc34d302acfdf1649d5e1bac653a9709171ad37b155", True],
        "num_data": ["84964a963c097c550b41a085bbf1ad93ba5a1046aa5495d86d62f9623ab89cc6", True],
        "data": ["1fac0f8fa2083fe32c21d081a46e455420f71c5f1f6959afb9f44623048e6875", False]
    }
    """
    result = {}
    for col, val in row.items():
        if col != 'tid':
            key = a2b_hex(keys[col][0].encode())
            if not keys[col][1]:  # if key is for fernet (is_numeric is False) create Fernet token
                cipher = Fernet(base64.urlsafe_b64encode(key))
                click.echo(val)
                result[col] = int_from_bytes(cipher.decrypt(val.encode()))
            else:  # if key is for OPE (is_numeric is True) create OPE cipher
                cipher = instantiate_ope_cipher(key)
                result[col] = cipher.decrypt(val)
        else:
            result[col] = val
    return result


def is_fake(row_values, row_correctness_hash):
    """
    Check whether row is fake tuple based on "correctness_hash" attribute in row and computed hash
    from other attributes in row.
    :param row_correctness_hash
    :param row_values: dict with keys as column names and values as values from server DB (decrypted using `decrypt_row`)
        example: [-959, 1000, -980, 1]
    :return: bool, based on correctness hash check
    """
    secret = ''.join(map(str, row_values)) + "1"
    return bcrypt.verify(secret, row_correctness_hash)


def verify_integrity_data(expected_tuples, present_rows):
    """
    :param expected_tuples: list of dicts with keys as column names and values as values from server DB
        (generated fake tuples, that should be present in DB)
    :param present_rows: list of dicts with keys as column names and values as values from server DB
        (queried tuples)
    :return: False if any of the rows does not satisfy 'fakeness' check of if there less/more fake
    rows than there should be
    """
    return expected_tuples == present_rows


def generate_fake_tuples_in_range(fake_tuple_info):
    """
    Generates all fake tuples in <"lower_bound", "upper_bound"> range and verifies them againts :param fake_rows.
    :param fake_tuple_info: example: {
                    "added": {
                        "function_name": "triangle_wave",
                        "lower_bound": 5,
                        "upper_bound": 11,
                        "is_numeric": True
                    }
    :return: list of dicts (each dict contains single tuple with keys as column names and values)
    """
    try:
        from client.device.commands import GENERATING_FUNCTIONS
    except ImportError:
        from device.commands import GENERATING_FUNCTIONS
    fake_tuple_col_values = {}
    fake_tuples = []
    lb, ub = 0, 0
    for col, val in fake_tuple_info.items():
        lb = fake_tuple_info[col]["lower_bound"]
        ub = fake_tuple_info[col]["upper_bound"] + 1
        # fake_tuple_col_values[col] = list(GENERATING_FUNCTIONS[val["function_name"]]())[lb:ub]
        func_list = list(GENERATING_FUNCTIONS[val["function_name"]]())
        fake_tuple_col_values[col] = func_list[lb:ub]
    for no, i in enumerate(range(lb, ub)):
        fake_tuples.append({"added": fake_tuple_col_values["added"][no],
                            "num_data": fake_tuple_col_values["num_data"][no],
                            "data": fake_tuple_col_values["data"][no],
                            "tid": i})
    return fake_tuples


def _setup_client(user_id):
    def on_publish(client, userdata, result):
        click.echo("Data published")

    client = paho.Client(user_id)
    client.on_publish = on_publish
    client.tls_set(ca_certs=os.path.join(os.path.dirname(__file__), "certs/server.crt"),
                   certfile=None,
                   keyfile=None,
                   tls_version=ssl.PROTOCOL_TLSv1_2)
    client.tls_insecure_set(True)
    client.connect(MQTT_BROKER, MQTT_PORT)
    return client


@user.command()
@click.argument('username')
@click.option('--token', envvar='AA_ACCESS_TOKEN')
def attr_auth_set_api_username(username, token):
    data = {"api_username": username, "access_token": token}
    r = requests.post(AA_URL_SET_USERNAME, params=data, verify=VERIFY_CERTS)
    click.echo(r.content.decode('unicode-escape'))


@user.command()
@click.option('--token', envvar='AA_ACCESS_TOKEN')
def get_attr_auth_keys(token):
    data = {"access_token": token}
    r = requests.post(AA_URL_SETUP, params=data, verify=VERIFY_CERTS)
    content = json.loads(r.content.decode('unicode-escape'))
    click.echo(f"Saving keys to {path}")
    db = TinyDB(path)
    table = db.table(name='aa_keys')
    doc = table.get(where('public_key').exists() & where('master_key').exists())
    data = {"public_key": content["public_key"], "master_key": content["master_key"]}
    if doc:
        table.update(data)
    else:
        table.insert(data)


@user.command()
@click.argument('attr_list')
@click.argument('receiver_id')
@click.option('--token', envvar='AA_ACCESS_TOKEN')
def attr_auth_keygen(attr_list, receiver_id, token):
    db = TinyDB(path)
    table = db.table(name='aa_keys')
    doc = table.get(where('public_key').exists() & where('master_key').exists())
    if not doc:
        with click.Context(get_attr_auth_keys) as ctx:
            click.echo(f"Master key not present, please use: {ctx.command.name}")
            click.echo(get_attr_auth_keys.get_help(ctx))
            return
    data = {
        "access_token": token,
        "master_key": doc['master_key'],
        "attr_list": re.sub('[\']', '', attr_list),
        "receiver_id": receiver_id
    }
    r = requests.post(AA_URL_KEYGEN, params=data, verify=VERIFY_CERTS)
    click.echo(r.content.decode('unicode-escape'))


@user.command()
@click.argument('message')
@click.argument('policy_string')
@click.option('--token', envvar='AA_ACCESS_TOKEN')
def attr_auth_encrypt(message, policy_string, token):
    data = {
        "access_token": token,
        "message": message,
        "policy_string": policy_string
    }
    r = requests.post(AA_URL_ENCRYPT, params=data, verify=VERIFY_CERTS)
    click.echo(r.content.decode('unicode-escape'))


@user.command()
@click.argument('owner_username')
@click.argument('ciphertext')  # TODO allow specifying file path
@click.option('--token', envvar='AA_ACCESS_TOKEN')
def attr_auth_decrypt(owner_username, ciphertext, token):
    data = {
        "access_token": token,
        "api_username": owner_username,
        "ciphertext": ciphertext
    }
    r = requests.post(AA_URL_DECRYPT, params=data, verify=VERIFY_CERTS)
    click.echo(r.content.decode('unicode-escape'))


if __name__ == '__main__':
    # json_data = json.loads(create_device_type("test desc").content.decode("utf-8"))
    # print(json_data)
    # print(create_device(json_data["type_id"]).content.decode("utf-8"))
    # send_message()
    ...
