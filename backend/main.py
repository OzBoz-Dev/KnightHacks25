from flask import Flask, request, jsonify
import sqlite3
from pathlib import Path
import db_helper

app = Flask(__name__)

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

# Magnet APIs
'''
    JSON Schema for magnet:
    {
        "id": INTEGER,
        "fridge_id": INTEGER,
        "user_id": TEXT,
        "text": TEXT,
        "color": TEXT,
        "x": REAL,
        "y": REAL,
        "image_url": TEXT,
        "created_at": TEXT/TIMESTAMP
    }
'''
@app.route('/api/magnets/', methods=['GET'])
def get_magnet_by_id():
    data = request.json
    if not data or 'id' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    magnet_id = data['id']
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM magnets WHERE id = ?', (magnet_id,))
    # Fetch all records so that the key is also included in the response
    
    magnets = cursor.fetchone()
    conn.close()
    return jsonify(dict(magnets))

@app.route('/api/magnets/', methods=['POST'])
def create_magnet():
    data = request.json
    if not data:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()        
        cursor.execute('''
            INSERT INTO magnets (fridge_id, user_id, text, color, x, y, image_url)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            ''', 
            (data['fridge_id'], data['user_id'], data['text'], data['color'], data['x'], data['y'], data['image_url'])
        )
        id = cursor.lastrowid
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Magnet created successfully', 'id' : id}, 201)

@app.route('/api/magnets/', methods=['PATCH'])
def update_magnet():
    data = request.json
    if not data or 'id' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()        
        cursor.execute('''
            UPDATE magnets
            SET fridge_id = ?, user_id = ?, text = ?, color = ?, x = ?, y = ?, image_url = ?
            WHERE id = ?
            ''', 
            (data['fridge_id'], data['user_id'], data['text'], data['color'], data['x'], data['y'], data['image_url'], data['id'])
        )
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Magnet updated successfully'}, 200)

@app.route('/api/magnets/', methods=['DELETE'])
def delete_magnet():
    data = request.json
    if not data or 'id' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()        
        cursor.execute('DELETE FROM magnets WHERE id = ?', (data['id'],))
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Magnet deleted successfully'}, 200)

# Fridge APIs
'''
JSON Schema for fridge:
{
    "fridge_id": INTEGER,
    "name": TEXT,
    "created_at": TEXT/TIMESTAMP,
    "magnets": [LIST OF MAGNET OBJECTS]
}
'''
@app.route('/api/fridges/', methods=['GET'])
def get_fridge_by_id():
    data = request.json
    if not data or 'fridge_id' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    fridge_id = data['fridge_id']
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM fridges WHERE fridge_id = ?', (fridge_id,))
        fridge = cursor.fetchone()
        fridge_dict = dict(fridge)
        fridge_dict['magnets'] = [dict(magnet) for magnet in cursor.execute('SELECT * FROM magnets WHERE fridge_id = ?', (fridge_id,)).fetchall()]
        conn.close()
        return jsonify(fridge_dict)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/fridges/', methods=['POST'])
def create_fridge():
    data = request.json
    if not data or 'name' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()        
        cursor.execute('''
            INSERT INTO fridges (name, user_id)
            VALUES (?, ?)
            ''', 
            (data['name'], data['user_id'])
        )
        fridge_id = cursor.lastrowid
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Fridge created successfully', 'fridge_id' : fridge_id}, 201)

@app.route('/api/fridges/', methods=['PATCH'])
def update_fridge():
    data = request.json
    if not data or 'fridge_id' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()        
        cursor.execute('''
            UPDATE fridges
            SET name = ?
            WHERE fridge_id = ?
            ''', 
            (data['name'], data['fridge_id'])
        )
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Fridge updated successfully'}, 200)

@app.route('/api/fridges/', methods=['DELETE'])
def delete_fridge():
    data = request.json
    if not data or 'fridge_id' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()        
        cursor.execute('DELETE FROM fridges WHERE fridge_id = ?', (data['fridge_id'],))
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Fridge deleted successfully'}, 200)


if __name__ == '__main__':
    app.run(debug=True)