from flask import Blueprint, request, jsonify
from flask_login import LoginManager
import db_helper

users = Blueprint('users', __name__)
login_manager = LoginManager()

@login_manager.user_loader
def load_user(user_id):
    return User.get(user_id)

@users.route('/login', methods=['GET','POST'])
def login():
    