from flask import Blueprint, request, jsonify
import db_helper

magnets = Blueprint('magnets', __name__)

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
@magnets.route('/api/magnets/', methods=['GET'])
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

@magnets.route('/api/magnets/', methods=['POST'])
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

@magnets.route('/api/magnets/', methods=['PATCH'])
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

@magnets.route('/api/magnets/', methods=['DELETE'])
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