from flask import Blueprint

web = Blueprint('web', __name__, template_folder="../templates")

from . import views, forms  # noqa pylint: disable=wrong-import-position
