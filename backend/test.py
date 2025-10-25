import requests
import sqlite3
import db_helper

def test_magnet_endpoint():
    test_id = 5
    url = 'http://localhost:5000/api/magnets/'
    response = requests.get(url, json={'id': test_id})
    print(response.text)
    response = requests.post(url, json={
        'fridge_id': 1,
        'user_id': 'user123',
        'text': 'Sample magnet text',
        'color': 'blue',
        'x': 100.0,
        'y': 200.0,
        'image_url': 'http://example.com/sample.png'
    })
    print (response.text)
    
    response = requests.patch(url, json={
        'id' : test_id,
        'fridge_id': 1,
        'user_id': 'user123',
        'text': 'Sample magnet text',
        'color': 'blue',
        'x': 100.0,
        'y': 200.0,
        'image_url': 'http://example.com/sample.png'
    })
    print(response.text)
    print(requests.get(url, json={'id': test_id}).text)
    response = requests.delete(url, json={'id': test_id})
    print(response.text)



test_magnet_endpoint()
magnets = db_helper.get_connection().execute('SELECT * FROM magnets').fetchall()
for magnet in magnets:
    print(dict(magnet))