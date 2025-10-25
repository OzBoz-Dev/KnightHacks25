import sqlite3

def init_magnets():
    conn = sqlite3.connect('../data/magnets.db')
    cursor = conn.cursor()
    
    # Create a sample table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS magnets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            test TEXT,
            color TEXT,
            x REAL,
            y REAL,
            image_url TEXT
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()
    
def test_magnets():
    conn = sqlite3.connect('../data/magnets.db')
    cursor = conn.cursor()
    # Insert a sample record
    cursor.execute('''
        INSERT INTO magnets (user_id, test, color, x, y, image_url)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', ('user123', 'This is a test magnet', 'red', 100.0, 150.0, 'http://example.com/image.png'))
    
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
    conn = sqlite3.connect('../data/magnets.db')
    cursor = conn.cursor()