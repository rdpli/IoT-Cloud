from flask import render_template, request, flash, redirect, url_for

from app.app_setup import db, client
from app.models.user import User

from app.web import web
from app.web.forms import PublishForm


@web.route('/')
def index():
    return render_template('index.html', title='Home')


@web.route('/publish', methods=['GET', 'POST'])
def publish():  # TODO write tests
    form = PublishForm(request.form)
    if request.method == 'POST' and form.validate():
        client.publish(form.topic.data, form.message.data)
        flash('Message Send.')  # TODO this doesnt display
        return redirect(url_for('web.index'))
    return render_template('publish.html', title='Publish to Topic', form=form)