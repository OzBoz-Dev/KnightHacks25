from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, KnightHacks 2025!"

@app.route('/api/magnets/', methods=['GET'])
def get_magnets():
    conn = sqlite3.connect('../data/magnets.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM magnets')
    magnets = cursor.fetchall()
    conn.close()
    return {'magnets': magnets}

@app.route('/api/magnets/', methods=['POST'])
def create_magnet():
    data = request.json
    if not data:
        return jsonify({'error': 'Invalid input'}), 400
    conn = sqlite3.connect('../data/magnets.db')
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO magnets (user_id, test, color, x, y, image_url)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (data['user_id'], data['test'], data['color'], data['x'], data['y'], data['image_url'])
    )
    conn.commit()
    conn.close()
    return jsonify({'message': 'Magnet created successfully'}, 201
    )


if __name__ == '__main__':
    app.run(debug=True)