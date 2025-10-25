import sqlite3
import db_helper

def init_db():
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS fridges (
            fridge_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            user_id TEXT,
            name TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )             
    '''
    )
    
    # Create a sample table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS magnets (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            fridge_id INTEGER,
            user_id TEXT,
            text TEXT,
            color TEXT,
            x REAL,
            y REAL,
            image_url TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (fridge_id) REFERENCES fridges(fridge_id) ON DELETE CASCADE
        )
        '''
    )
    conn.commit()
    conn.close()
    
def bobby_tables():
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    cursor.execute('DROP TABLE IF EXISTS magnets')
    cursor.execute('DROP TABLE IF EXISTS fridges')
    
def init_all():
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    # Insert a sample fridge
    cursor.execute('''
        INSERT INTO fridges (user_id, name)
        VALUES (?, ?)
    ''', ('user123', 'My Fridge'))
    # Insert a sample magnet
    cursor.execute('''
        INSERT INTO magnets (fridge_id, user_id, text, color, x, y, image_url)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', (1, 'user123', 'This is a test magnet', 'red', 100.0, 150.0, 'http://example.com/image.png'))
    conn.commit()
    conn.close()
    
if __name__ == '__main__':
    # bobby_tables()
    init_db()
    init_all()
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    print(cursor.execute('SELECT * FROM magnets').fetchall())
    print(cursor.execute('SELECT * FROM fridges').fetchall())