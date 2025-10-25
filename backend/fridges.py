from flask import Blueprint, request, jsonify
import db_helper

fridges = Blueprint('fridges', __name__)

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
@fridges.route('/api/fridges/', methods=['GET'])
def get_fridge_by_id():
    data = request.args.get('id')
    if not data:
        return get_all_fridges()
    fridge_id = int(data)
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

def get_all_fridges():
    try:
        conn = db_helper.get_connection()
        cursor = conn.cursor()
        fridges = cursor.execute('SELECT * FROM fridges').fetchall()
        fridges_list = []
        for fridge in fridges:
            fridge_dict = dict(fridge)
            fridge_id = fridge_dict['fridge_id']
            fridge_dict['magnets'] = [dict(magnet) for magnet in cursor.execute('SELECT * FROM magnets WHERE fridge_id = ?', (fridge_id,)).fetchall()]
            fridges_list.append(fridge_dict)
        conn.close()
        return jsonify(fridges_list)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@fridges.route('/api/fridges/', methods=['POST'])
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
    return jsonify({'message': 'Fridge created successfully', 'fridge_id' : fridge_id, 'status': 201})

@fridges.route('/api/fridges/', methods=['PATCH'])
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

@fridges.route('/api/fridges/', methods=['DELETE'])
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