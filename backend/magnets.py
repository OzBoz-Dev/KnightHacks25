from flask import Blueprint, request, jsonify
from users import token_required
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
@token_required
def create_magnet(user):
    data = request.json
    if not data or not data['user_id']:
        return jsonify({'error': 'Invalid input'}), 400
    if data['user_id'] != user.username:
        return jsonify({'error': 'Unauthorized to create a magnet for this user'}), 403
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
    return jsonify({'message': 'Magnet created successfully', 'id' : id})

@magnets.route('/api/magnets/', methods=['PATCH'])
@token_required
def update_magnet(user):
    data = request.json
    if not data or 'id' not in data or data['id'] is None:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()   
        cursor.execute('SELECT * FROM magnets WHERE id = ?', (data['id'],))
        magnet = cursor.fetchone()
        
        if not magnet:
            return jsonify({'error': 'Fridge not found'}), 404
        if magnet['user_id'] != user.username:
            return jsonify({'error': 'Unauthorized to update this magnet'}), 403 
            
        cursor.execute('''
            UPDATE magnets
            SET text = ?, color = ?, x = ?, y = ?
            WHERE id = ?
            ''', 
            (data['text'], data['color'], data['x'], data['y'], data['id'])
        )
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Magnet updated successfully'}, 200)

@magnets.route('/api/magnets/', methods=['DELETE'])
@token_required
def delete_magnet(user):
    data = request.json
    if not data or 'id' not in data:
        return jsonify({'error': 'Invalid input'}), 400
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()       
        cursor.execute('SELECT * FROM magnets WHERE id = ?', (data['id'],))
        magnet = cursor.fetchone()
        
        if not magnet:
            return jsonify({'error': 'Fridge not found'}), 404
        if magnet['user_id'] != user.username:
            return jsonify({'error': 'Unauthorized to delete this magnet'}), 403   
        
        cursor.execute('DELETE FROM magnets WHERE id = ?', (data['id'],))
        conn.commit()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    return jsonify({'message': 'Magnet deleted successfully'}, 200)