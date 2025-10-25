import sqlite3
import db_helper

def init_magnets():
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    
    # Create a sample table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS magnets (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            FORIGN KEY (fridge_id) REFERENCES fridges(fridge_id) ON DELETE CASCADE,
            user_id TEXT,
            text TEXT,
            color TEXT,
            x REAL,
            y REAL,
            image_url TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )'''
    )
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS fridges (
            fridge_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            user_id TEXT,
            name TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP              
    '''
    )
    
    
    conn.commit()
    conn.close()
    
def test_magnets():
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    # Insert a sample record
    cursor.execute('''
        INSERT INTO magnets (user_id, text, color, x, y, image_url)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', ('user123', 'This is a test magnet', 'red', 100.0, 150.0, 'http://example.com/image.png'))
    # Insert a sample fridge
    cursor.execute('''
        INSERT INTO fridges (user_id, name)
        VALUES (?, ?)
    ''', ('user123', 'My Fridge'))
    conn.commit()
    
    # Fetch and print all records
    cursor.execute('SELECT * FROM magnets')
    records = cursor.fetchall()
    for record in records:
        print(record)
    
    conn.close()
    
if __name__ == '__main__':
    init_magnets()
    test_magnets()
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    print(cursor.execute('SELECT * FROM magnets').fetchall())