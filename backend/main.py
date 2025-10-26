from flask import Flask, request, jsonify
from flask_login import LoginManager
from flask_cors import CORS
from users import users
import sqlite3
from fridges import fridges
from magnets import magnets
import db_helper

app = Flask(__name__)
CORS(app, supports_credentials=True)
app.register_blueprint(fridges)
app.register_blueprint(magnets)
app.register_blueprint(users)
login_manager = LoginManager()
login_manager.init_app(app)

@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response

# Home
@app.route('/')
def home():
    return "Hello, KnightHacks 2025!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)