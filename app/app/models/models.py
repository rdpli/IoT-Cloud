import datetime
from uuid import uuid4
from sqlalchemy import func, and_
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.orm import relationship

from app.utils import is_number
from app.app_setup import db
from app.models.mixins import MixinGetById, MixinAsDict, MixinGetUsingJWT, MixinGetByUsername

scene_action_table = db.Table('scene_action',
                              db.Column("scene_id", db.Integer, db.ForeignKey('scene.id')),
                              db.Column('action_id', db.Integer, db.ForeignKey('action.id')),
                              extend_existing=True
                              )


class UserDevice(db.Model):
    __tablename__ = 'user_device'
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'), primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('device.id', ondelete='CASCADE'), primary_key=True)
    device_public_session_key = db.Column(db.String(250))
    added = db.Column(db.DateTime(timezone=True), onupdate=datetime.datetime.now)
    device = relationship("Device", back_populates="users")
    user = relationship("User", back_populates="devices")

    @classmethod
    def get_by_ids(cls, device_id, user_id):
        return db.session.query(UserDevice) \
            .filter(and_(UserDevice.device_id == device_id,
                         UserDevice.user_id == user_id)).first()


class User(MixinGetUsingJWT, MixinGetById, db.Model):
    __tablename__ = 'user'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), unique=False, nullable=True)
    email = db.Column(db.String(200), unique=False, nullable=True)
    access_token = db.Column(db.String(200), unique=True, nullable=False)
    access_token_update = db.Column(db.DateTime, nullable=False)
    device_types = relationship("DeviceType", back_populates="owner")
    devices = relationship("UserDevice", back_populates="user", cascade="all,delete")
    owned_devices = relationship("Device", back_populates="owner", cascade="all,delete")
    mqtt_creds = relationship("MQTTUser", uselist=False, cascade='all,delete', back_populates="user", passive_deletes=True)

    @classmethod
    def can_use_device(cls, user, device_id):
        if not is_number(device_id):
            return False
        q = db.session.query(
            db.session.query(User).
            join(UserDevice).
            filter(User.id == user.id).
            filter(UserDevice.device_id == device_id).
            exists()
        )
        return q.scalar()

    def create_mqtt_creds_for_user(self, password, session):
        session.flush()
        acls = [
            ACL(username=f"u:{self.id}", topic=f"u:{self.id}/server/", acc=2),
            ACL(username=f"u:{self.id}", topic=f"server/u:{self.id}/", acc=1)
        ]
        if self.mqtt_creds is None:
            self.mqtt_creds = MQTTUser(
                username=f"u:{self.id}",
                password_hash=password,
                user=self,
                user_id=self.id,
                acls=acls)
        else:
            self.mqtt_creds.password_hash = password
            self.mqtt_creds.acls = acls

    def add_acls_for_device(self, device_id):
        self.mqtt_creds.acls.extend([
            ACL(username=f"u:{self.id}", topic=f"u:{self.id}/d:{device_id}/", acc=2),
            ACL(username=f"u:{self.id}", topic=f"d:{device_id}/u:{self.id}/", acc=1),
            ACL(username=f"u:{self.id}", topic=f"d:{device_id}/u:{self.id}/", acc=4)  # NOTE: seems to be necessary because of the way paho.mqtt connects to broker
        ])

    def remove_acls_for_device(self, device_id):
        self.mqtt_creds.acls[:] = [acl for acl in self.mqtt_creds.acls if f"d:{device_id}/" not in acl.topic]

    @hybrid_property
    def is_registered_with_broker(self):
        return self.mqtt_creds is not None


class DeviceType(db.Model):
    __tablename__ = 'device_type'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    type_id = db.Column(UUID(as_uuid=True), unique=True, nullable=False, default=uuid4)
    description = db.Column(db.LargeBinary, nullable=False)
    devices = relationship("Device", cascade="all, delete-orphan", back_populates="device_type")
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    owner = relationship("User", back_populates="device_types")

    correctness_hash = db.Column(db.String(200), nullable=False)  # correctness_hash("description")


class Device(MixinGetById, MixinAsDict, db.Model):
    __tablename__ = 'device'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    status = db.Column(db.LargeBinary, default=b'0')  # NOTE: This could use OPE but domain is too small
    device_type = relationship("DeviceType", back_populates="devices")
    device_type_id = db.Column(db.Integer, db.ForeignKey('device_type.id'))
    users = relationship("UserDevice", back_populates="device", cascade='all,delete-orphan')
    data = relationship("DeviceData", back_populates="device", cascade='all,delete-orphan')
    actions = relationship("Action", back_populates="device", cascade="all,delete")

    owner_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    owner = relationship("User", back_populates="owned_devices")
    mqtt_creds = relationship("MQTTUser", uselist=False, back_populates="device", cascade='all,delete')

    name = db.Column(db.LargeBinary, nullable=False)
    name_bi = db.Column(db.String(200), unique=True, nullable=True, index=True)  # Blind index for .name

    correctness_hash = db.Column(db.String(200), nullable=False)  # correctness_hash("name")

    def create_mqtt_creds_for_device(self, password, session):
        session.flush()
        self.mqtt_creds = MQTTUser(
            username=f"d:{self.id}",
            password_hash=password,
            device=self,
            acls=[
                ACL(username=f"d:{self.id}", topic=f"u:{self.owner_id}/d:{self.id}/", acc=1),
                ACL(username=f"d:{self.id}", topic=f"d:{self.id}/u:{self.owner_id}/", acc=2),
                ACL(username=f"d:{self.id}", topic=f"d:{self.id}/server/+", acc=2),
                ACL(username=f"d:{self.id}", topic=f"d:{self.id}/server/", acc=2),
                ACL(username=f"d:{self.id}", topic=f"server/d:{self.id}/", acc=1)
            ])

    def add_action(self, name, name_bi, correctness_hash):
        self.actions.append(
            Action(name=name,
                   name_bi=name_bi,
                   correctness_hash=correctness_hash)
        )

    def add_acls_for_user(self, user_id):
        self.mqtt_creds.acls.extend([
            ACL(username=f"d:{self.id}", topic=f"u:{user_id}/d:{self.id}/", acc=1),
            ACL(username=f"d:{self.id}", topic=f"d:{self.id}/u:{user_id}/", acc=2)
        ])

    def remove_acls_for_user(self, user_id):
        self.mqtt_creds.acls[:] = [acl for acl in self.mqtt_creds.acls if f"u:{user_id}/" not in acl.topic]

    @classmethod
    def get_action_by_bi(cls, device_id, bi):
        return db.session.query(Action)\
            .join(cls)\
            .filter(cls.id == device_id)\
            .filter(Action.name_bi == bi)\
            .first()

    @classmethod
    def get_by_name_bi(cls, bi):
        return db.session.query(Device).filter(Device.name_bi == bi).first()


class MQTTUser(db.Model):
    __tablename__ = 'mqtt_user'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(200), unique=True, nullable=False)
    password_hash = db.Column(db.String(200), unique=False, nullable=False)
    superuser = db.Column(db.Integer, default=0)
    acls = relationship("ACL", cascade='all,delete-orphan', back_populates="mqtt_user")

    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'))
    user = relationship("User", back_populates="mqtt_creds")
    device_id = db.Column(db.Integer, db.ForeignKey('device.id', ondelete='CASCADE'))
    device = relationship("Device", back_populates="mqtt_creds")

    @hybrid_property
    def is_device(self):
        return self.device is not None


class ACL(db.Model):
    __tablename__ = 'acl'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    mqtt_user_id = db.Column(db.Integer, db.ForeignKey('mqtt_user.id', ondelete='CASCADE'))
    mqtt_user = relationship("MQTTUser", back_populates="acls")
    username = db.Column(db.String(200), nullable=False)
    topic = db.Column(db.String(200), unique=False, nullable=True)
    acc = db.Column(db.Integer)  # Access 1 = read-only; 2 = write-only; 3 = both


class DeviceData(MixinAsDict, db.Model):
    __tablename__ = 'device_data'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    tid = db.Column(db.LargeBinary)
    added = db.Column(db.BigInteger)
    num_data = db.Column(db.BigInteger)
    data = db.Column(db.LargeBinary)
    device_id = db.Column(db.Integer, db.ForeignKey('device.id', ondelete='CASCADE'))
    device = relationship("Device", back_populates="data")

    tid_bi = db.Column(db.String(200), unique=True, nullable=True, index=True)  # Blind index for .tid

    correctness_hash = db.Column(db.String(200), nullable=False)  # correctness_hash(str(985734000), b'\\001'.decode("utf-8"), str(66988873), str(tid))

    @classmethod
    def delete_by_tid_bi(cls, tid_bi, device_id):
        db.session.query(DeviceData) \
            .filter(and_(
                DeviceData.tid_bi == tid_bi,
                DeviceData.device_id == device_id,
            )).delete()


class Action(MixinGetById, db.Model):
    __tablename__ = 'action'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.LargeBinary, nullable=False)
    device_id = db.Column(db.Integer, db.ForeignKey('device.id', ondelete='CASCADE'))
    device = relationship("Device", back_populates="actions")

    name_bi = db.Column(db.String(200), unique=True, nullable=True, index=True)  # Blind index for .name

    correctness_hash = db.Column(db.String(200), nullable=False)  # correctness_hash("name")

    scenes = relationship(
        "Scene",
        secondary=scene_action_table,
        back_populates="actions", cascade="all,delete")

    @classmethod
    def get_by_name_bi(cls, bi):
        return db.session.query(Action).filter(Action.name_bi == bi).first()


class Scene(db.Model):
    __tablename__ = 'scene'
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.LargeBinary, nullable=False)
    description = db.Column(db.LargeBinary, nullable=False)
    actions = relationship(
        "Action",
        secondary=scene_action_table,
        back_populates="scenes",
        cascade="all,delete")

    correctness_hash = db.Column(db.String(200), nullable=False)  # correctness_hash("name", "description")

    name_bi = db.Column(db.String(200), unique=True, nullable=True, index=True)  # Blind index for .name

    @hybrid_property
    def owner(self):
        if self.actions is not None and len(self.actions) > 0:
            return self.actions[0].device.owner
        return None

    @classmethod
    def get_by_name_bi(cls, bi):
        return db.session.query(Scene).filter(Scene.name_bi == bi).first()

    def already_present(self, action):
        return action in self.actions


class AttrAuthUser(MixinGetByUsername, MixinGetUsingJWT, MixinGetById, db.Model):
    __table_args__ = {'extend_existing': True}
    __bind_key__ = 'attr_auth'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), unique=False, nullable=True)
    api_username = db.Column(db.String(200), unique=True, nullable=True)
    access_token = db.Column(db.String(200), unique=True, nullable=False)
    access_token_update = db.Column(db.DateTime, nullable=False)
    master_keypair = relationship("MasterKeypair", back_populates="attr_auth_user", uselist=False, cascade="all,delete")

    private_keys = relationship("PrivateKey", backref="user", foreign_keys=lambda: PrivateKey.user_id, cascade="all,delete")


class PrivateKey(db.Model):
    __table_args__ = {'extend_existing': True}
    __bind_key__ = 'attr_auth'

    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.LargeBinary, nullable=False)
    key_update = db.Column(db.DateTime(timezone=True), server_default=func.now())
    attributes = relationship("Attribute", backref="private_key", cascade="all,delete")

    user_id = db.Column(db.Integer, db.ForeignKey('attr_auth_user.id'))

    challenger_id = db.Column(db.Integer, db.ForeignKey('attr_auth_user.id'))
    challenger = relationship("AttrAuthUser", uselist=False, foreign_keys=[challenger_id])

    device_id = db.Column(db.Integer, nullable=False)


class MasterKeypair(db.Model):
    __table_args__ = {'extend_existing': True}
    __bind_key__ = 'attr_auth'
    __tablename__ = 'master_keypair'

    id = db.Column(db.Integer, primary_key=True)
    data_public = db.Column(db.LargeBinary, nullable=False)
    data_master = db.Column(db.LargeBinary, nullable=False)
    key_update = db.Column(db.DateTime(timezone=True), server_default=func.now())
    attr_auth_user_id = db.Column(db.Integer, db.ForeignKey('attr_auth_user.id'))
    attr_auth_user = relationship("AttrAuthUser", back_populates="master_keypair")


class Attribute(db.Model):
    __table_args__ = {'extend_existing': True}
    __bind_key__ = 'attr_auth'

    id = db.Column(db.Integer, primary_key=True)
    value = db.Column(db.String(200), unique=False, nullable=True)

    private_key_id = db.Column(db.Integer, db.ForeignKey('private_key.id'))
