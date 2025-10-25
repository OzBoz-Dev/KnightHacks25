from flask import Blueprint, request, jsonify
from flask_login import LoginManager, UserMixin, login_user
from werkzeug.security import check_password_hash, generate_password_hash
import jwt
import datetime
import db_helper

users = Blueprint('users', __name__)
SECRET_KEY = 'VERYUNSECURESECRETKEYPLSCHANGE'
login_manager = LoginManager()

class User(UserMixin):
    def __init__(self, username, password_hash):
        self.username = username
        self.password_hash = password_hash

    @staticmethod
    def get_user_by_username(username):
        conn = db_helper.get_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM users WHERE username = ?', (username,))
        user_row = cursor.fetchone()
        conn.close()
        if user_row:
            return User(user_row['username'], user_row['password_hash'])
        return None

@users.route('/api/users/register/', methods=['POST'])
def register():
    data = request.json
    if not data or 'username' not in data or 'password' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    username = data['username']
    password = data['password']
    
    if User.get_user_by_username(username):
        return jsonify({'error': 'Username already exists'}), 409
    
    password_hash = generate_password_hash(password)
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO users (username, password_hash)
            VALUES (?, ?)
        ''', (username, password_hash))
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
    return jsonify({'message': 'User registered successfully'}), 201

@users.route('/api/users/login/', methods=['POST'])
def login():
    data = request.json
    if not data or 'username' not in data or 'password' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    username = data['username']
    password = data['password']
    
    user = User.get_user_by_username(username)
    if not user or not(check_password_hash(user.password_hash, password)):
        return jsonify({'error': 'Invalid username or password'}), 401
    
    login_user(user)
    token = jwt.encode({'id' : user.username}, SECRET_KEY, algorithm='HS256')
    
    return jsonify({"token": token})

@users.route('/api/users/delete/', methods = ['DELETE'])
def delete_user():
    data = request.json
    if not data or 'username' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    username = data['username']
    
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM users WHERE username = ?', (username,))
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
    return jsonify({'message': 'User deleted successfully'}), 200
