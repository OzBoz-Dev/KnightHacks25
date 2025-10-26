from flask import Blueprint, request, jsonify
from flask_login import LoginManager, UserMixin
from werkzeug.security import check_password_hash, generate_password_hash
from functools import wraps
import jwt
import datetime
import os
from dotenv import load_dotenv
import db_helper

load_dotenv('secrets.env')
users = Blueprint('users', __name__)
SECRET_KEY = os.getenv('SECRET_KEY', 'UNSECURE_DEFAULT_KEY')
login_manager = LoginManager()

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token:
            return jsonify({'error': 'Token is missing!'}), 401
        try:
            data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
            current_user = User.get_user_by_username(data['id'])
        except:
            return jsonify({'error': 'Token is invalid!'}), 401
        return f(current_user, *args, **kwargs)

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

# Return the username associated with a token
@users.route('/api/users/', methods=['GET'])
def get_username_by_token():
    data = request.args.get('token')
    if not data:
        return jsonify({'error': 'Invalid input'}), 400
    token = data
    try:
        decoded = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        username = decoded['id']
        if not User.get_user_by_username(username):
            return jsonify({'error': 'User not found'}), 404
        return jsonify({'username' : username})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Register a new user
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

# Login an existing user, return their token
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
    
    token = jwt.encode({'id' : user.username}, SECRET_KEY, algorithm='HS256')
    
    return jsonify({"token": token})

@users.route('/api/users/', methods = ['DELETE'])
def delete_user():
    data = request.json
    if not data or 'token' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    token = data['token']
    
    try:
        decoded = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        username = decoded['id']
        if not User.get_user_by_username(username):
            return jsonify({'error': 'User not found'}), 404
        conn = db_helper.get_connection()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM users WHERE username = ?', (username,))
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
    return jsonify({'message': 'User deleted successfully'}), 200

