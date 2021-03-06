import base64
from unittest import mock

import pytest
from cryptography.fernet import Fernet
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.ec import EllipticCurvePublicKey
from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey, X25519PublicKey
from cryptography.hazmat.primitives.serialization import load_pem_public_key
from sqlalchemy import and_

from app.app_setup import db
from app.consts import DEVICE_ID_MISSING_ERROR_MSG, PUBLIC_KEY_MISSING_ERROR_MSG, UNAUTHORIZED_USER_ERROR_MSG, NO_PUBLIC_KEY_ERROR_MSG
from app.models.models import UserDevice
from client.crypto_utils import derive_key
from tests.conftest import assert_got_error_from_post, assert_got_data_from_post, assert_got_error_from_get, \
    get_data_from_post


def test_dh_exchange():
    # Create keys
    private_key_alice = X25519PrivateKey.generate()
    public_key_alice = private_key_alice.public_key()

    private_key_bob = X25519PrivateKey.generate()
    public_key_bob = private_key_bob.public_key()

    # Serialize keys
    public_pem_alice = public_key_alice.public_bytes()
    public_pem_bob = public_key_bob.public_bytes()

    # Deserialize keys
    deserialized_public_key_alice = X25519PublicKey.from_public_bytes(public_pem_alice)
    deserialized_public_key_bob = X25519PublicKey.from_public_bytes(public_pem_bob)
    assert isinstance(deserialized_public_key_alice, X25519PublicKey)
    assert isinstance(deserialized_public_key_bob, X25519PublicKey)

    # Exchange keys
    shared_key_alice = private_key_alice.exchange(deserialized_public_key_bob)
    shared_key_bob = private_key_bob.exchange(deserialized_public_key_alice)

    # Verify shared keys
    assert shared_key_alice == shared_key_bob

    # Derive New Shared keys manually
    derived_key_alice = derive_key(shared_key_alice)
    derived_key_bob = derive_key(shared_key_bob)

    assert derived_key_alice == derived_key_bob

    # Derive New Shared keys with Fernet
    derived_key_alice = Fernet(base64.urlsafe_b64encode(shared_key_alice))
    derived_key_bob = Fernet(base64.urlsafe_b64encode(shared_key_bob))

    assert derived_key_alice._signing_key == derived_key_bob._signing_key
    assert derived_key_alice._encryption_key == derived_key_bob._encryption_key


def test_ec_exchange():
    # Create keys
    private_key_alice = ec.generate_private_key(ec.SECP384R1(), default_backend())
    public_key_alice = private_key_alice.public_key()

    private_key_bob = ec.generate_private_key(ec.SECP384R1(), default_backend())
    public_key_bob = private_key_bob.public_key()

    # Serialize keys
    public_pem_alice = public_key_alice.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo)
    public_pem_bob = public_key_bob.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo)

    # Deserialize keys
    deserialized_public_key_alice = load_pem_public_key(public_pem_alice, backend=default_backend())
    deserialized_public_key_bob = load_pem_public_key(public_pem_bob, backend=default_backend())
    assert isinstance(deserialized_public_key_alice, EllipticCurvePublicKey)
    assert isinstance(deserialized_public_key_bob, EllipticCurvePublicKey)

    # Exchange keys
    shared_key_alice = private_key_alice.exchange(ec.ECDH(), deserialized_public_key_bob)
    shared_key_bob = private_key_bob.exchange(ec.ECDH(), deserialized_public_key_alice)

    # Verify shared keys
    assert shared_key_alice == shared_key_bob

    # Derive New Shared keys manually
    derived_key_alice = derive_key(shared_key_alice)
    derived_key_bob = derive_key(shared_key_bob)

    assert derived_key_alice == derived_key_bob

    # Derive New Shared keys with Fernet
    derived_key_alice = Fernet(base64.urlsafe_b64encode(shared_key_alice[:32]))
    derived_key_bob = Fernet(base64.urlsafe_b64encode(shared_key_bob[:32]))

    assert derived_key_alice._signing_key == derived_key_bob._signing_key
    assert derived_key_alice._encryption_key == derived_key_bob._encryption_key


def test_exchange_session_keys_missing_public_key(client, access_token):
    data = {
        "access_token": access_token
    }
    assert_got_error_from_post(client, '/api/exchange_session_keys', data, 400, PUBLIC_KEY_MISSING_ERROR_MSG)


@pytest.mark.parametrize("endpoint", [
    "exchange_session_keys",
    "retrieve_public_key"
])
def test_exchange_session_keys_and_retrieve_public_key_missing_device_id(client, access_token, endpoint):
    data = {
        "access_token": access_token,
        "public_key": '-----BEGIN PUBLIC KEY-----\nMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEDM0W/Tn8gv7VjDzvGMqke8rcfZe2zWAG\nRdABvWRRZNmioOeH8U/gFBgiDd9Nd61JuTa3BQx'
                      'WUYPEMNsSF3yWjlWlzgJCxwJX\nE80D4mcE/gNLI3+86bs4q3wWcJY0fk3I\n-----END PUBLIC KEY-----\n'
    }
    assert_got_error_from_post(client, f'/api/{endpoint}', data, 400, DEVICE_ID_MISSING_ERROR_MSG)


@pytest.mark.parametrize("endpoint", [
    "exchange_session_keys",
    "retrieve_public_key"
])
def test_exchange_session_keys_and_retrieve_public_key_unauthorized_user(client, access_token_two, endpoint):
    data = {
        "access_token": access_token_two,
        "public_key": '-----BEGIN PUBLIC KEY-----\nMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEDM0W/Tn8gv7VjDzvGMqke8rcfZe2zWAG\nRdABvWRRZNmioOeH8U/gFBgiDd9Nd61JuTa3BQx'
                      'WUYPEMNsSF3yWjlWlzgJCxwJX\nE80D4mcE/gNLI3+86bs4q3wWcJY0fk3I\n-----END PUBLIC KEY-----\n',
        "device_id": 23
    }

    assert_got_error_from_post(client, f'/api/{endpoint}', data, 400, UNAUTHORIZED_USER_ERROR_MSG)


def test_exchange_session_keys_success(client, access_token_two):
    public_key = '-----BEGIN PUBLIC KEY-----\nMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEDM0W/Tn8gv7VjDzvGMqke8rcfZe2zWAG\nRdABvWRRZNmioOeH8U/gFBgiDd9Nd61JuTa3BQx' \
                 'WUYPEMNsSF3yWjlWlzgJCxwJX\nE80D4mcE/gNLI3+86bs4q3wWcJY0fk3I\n-----END PUBLIC KEY-----\n'

    data = {
        "access_token": access_token_two,
        "public_key": public_key,
        "device_id": 34
    }
    with mock.patch('app.app_setup.client.publish') as publish:
        assert_got_data_from_post(client, '/api/exchange_session_keys', data)
        publish.assert_called_once()


def test_retrieve_public_key_no_such_key(client, access_token):
    data = {
        "device_id": 23,
        "access_token": access_token
    }
    assert_got_error_from_post(client, '/api/retrieve_public_key', data, 400, NO_PUBLIC_KEY_ERROR_MSG)


@pytest.mark.parametrize('setup_user_device_public_key',
                         [(23,
                           1,
                           '-----BEGIN PUBLIC KEY-----\n'
                           'MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAE2rD6Bhju8WSEFogdBxZt/N+n7ziUPi5C\n'
                           'QU1gSQQDNm57fdDuYNDOR7Wwb1fq5tSl2TC1D6WRTIt1gzzCsApGpZ3PIs7Wdbil\n'
                           'eJL/ETGa2Sqwav7JDH4r0V30sF4NqDok\n'
                           '-----END PUBLIC KEY-----\n',
                           'testing')
                          ], indirect=True)
def test_retrieve_public_key_success(client, app_and_ctx, access_token, setup_user_device_public_key):
    device_id = 23
    data = {
        "device_id": device_id,
        "access_token": access_token
    }
    status_code, json_data = get_data_from_post(client, '/api/retrieve_public_key', data)

    assert status_code == 200
    assert (json_data["device_public_key"]).startswith("-----BEGIN PUBLIC KEY----")
    app, ctx = app_and_ctx
    with app.app_context():
        user_device = db.session.query(UserDevice) \
            .filter(and_(UserDevice.device_id == device_id,
                         UserDevice.user_id == 1)).first()
        assert user_device.device_public_session_key is None
        assert user_device.added is None
