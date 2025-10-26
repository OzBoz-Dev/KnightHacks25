import sqlite3
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))
from backend import db_helper

def init_db():
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    
    # User table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            username TEXT PRIMARY KEY NOT NULL,
            password_hash TEXT
        )
    ''')
    
    # Fridge table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS fridges (
            fridge_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            user_id TEXT,
            name TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
            )             
    '''
    )
    
    # Magnet table
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
    cursor.execute('DROP TABLE IF EXISTS users')
    
def init_all():
    conn = db_helper.get_connection()
    cursor = conn.cursor()
    # Insert a sample user
    cursor.execute('''
        INSERT INTO users (username, password_hash)
        VALUES (?, ?)
    ''', ('user123', 'passwordHAShED'))
    
    # Insert a sample fridge
    cursor.execute('''
        INSERT INTO fridges (user_id, name)
        VALUES (?, ?)
    ''', ('user123', 'My Fridge'))
    
    # Insert a sample magnet
    cursor.execute('''
        INSERT INTO magnets (fridge_id, user_id, text, color, x, y, image_url)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', (4, 'user123', 'This is a test magnet', 'red', 100.0, 150.0, 'http://example.com/image.png'))
    
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
    print(cursor.execute('SELECT * FROM users').fetchall())