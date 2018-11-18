# -*- coding: utf-8 -*-
import base64
import json
from paho.mqtt.client import MQTTMessage

from app.api.endpoints import DEVICE_TYPE_ID_MISSING_ERROR_MSG, DEVICE_TYPE_ID_INCORRECT_ERROR_MSG
from app.errors.errors import SOMETHING_WENT_WRONG_MSG
from app.models.models import DeviceType, Device, DeviceData
from app.app_setup import client as mqtt_client
from client.crypto_utils import encrypt

from tests.test_utils.fixtures import *
from tests.test_utils.utils import is_valid_uuid


def test_mqtt_client(app):
    assert mqtt_client._ssl is True


def test_mqtt_on_message(app):
    msg = MQTTMessage(topic=b"not_save_data")
    msg.payload = b"{'device_id': 111111, 'device_data': 'test_data'}"  # not present yet
    from app.mqtt.mqtt import handle_on_message
    app, ctx = app
    with app.app_context():
        device_data_count = db.session.query(DeviceData).count()

        handle_on_message(None, None, msg, app, db)
        assert device_data_count == db.session.query(DeviceData).count()  # 0 == 0
        msg.topic = b"save_data"
        assert device_data_count == db.session.query(DeviceData).count()  # 0 == 0
        db.session.add(Device(id=111111))
        db.session.commit()
        msg.payload = b"{'device_id': 111111, 'device_data': 'test_data'}"
        handle_on_message(None, None, msg, app, db)
        assert device_data_count + 1 == db.session.query(DeviceData).count()  # 0 + 1 == 1


def test_index(client):
    response = client.get('/')
    assert "Hi from app!" in str(response.data)


def test_error_handler(client):
    response = client.post('/nonvalidurl', follow_redirects=False)
    assert response.status_code == 404
    json_data = json.loads(response.data.decode("utf-8"))
    assert (json_data["error"]) == SOMETHING_WENT_WRONG_MSG


def test_publish(client):
    response = client.get('/publish')
    assert response.status_code == 200

    response = client.post('/publish', data=dict(
        topic="",
        message=""
    ), follow_redirects=False)
    assert response.status_code == 200

    response = client.post('/publish', data=dict(
        topic="flask_test",
        message="message"
    ), follow_redirects=False)
    assert response.status_code == 302


def test_api_publish(client):
    iv, ciphertext, tag = encrypt(
        b'f\x9c\xeb Lj\x13n\x84B\xf5S\xb5\xdfnl53d\x10\x12\x92\x82\xe1\xe3~\xc8*\x16\x9f\xd69',
        b"{\"data\": \"secret\"}",
        b"authenticated but not encrypted payload"
    )
    response = client.post('/api/publish', query_string=dict(
        ciphertext=str(base64.b64encode(ciphertext), 'utf-8'),
        tag=str(base64.b64encode(tag), 'utf-8'),
        topic="flask_test"
    ), follow_redirects=True)

    assert response.status_code == 200


def test_api_dt_create(client):
    data = {"description": "non-empty"}
    response = client.post('/api/device_type/create', query_string=data, follow_redirects=True)
    assert response.status_code == 200
    json_data = json.loads(response.data.decode("utf-8"))
    assert is_valid_uuid(json_data["type_id"])

    data = {"not-description": "non-empty"}
    response = client.post('/api/device_type/create', query_string=data, follow_redirects=True)
    assert response.status_code == 400


def test_api_dv_create(client, app):
    data = {"not-type_id": "non-empty"}
    response = client.post('/api/device/create', query_string=data, follow_redirects=True)
    assert response.status_code == 400
    json_data = json.loads(response.data.decode("utf-8"))
    assert (json_data["error"]) == DEVICE_TYPE_ID_MISSING_ERROR_MSG

    data = {"type_id": "non-valid - not present in DB"}
    response = client.post('/api/device/create', query_string=data, follow_redirects=True)
    assert response.status_code == 400
    json_data = json.loads(response.data.decode("utf-8"))
    assert (json_data["error"]) == DEVICE_TYPE_ID_INCORRECT_ERROR_MSG

    app, ctx = app

    with app.app_context():
        dt = DeviceType()
        db.session.add(dt)
        db.session.commit()
        data = {"type_id": str(dt.type_id)}

    response = client.post('/api/device/create', query_string=data, follow_redirects=True)
    assert response.status_code == 200
    json_data = json.loads(response.data.decode("utf-8"))
    assert "id" in json_data


def test_abe():
    from .context import ABE_main
    assert ABE_main.test_abe() is True
