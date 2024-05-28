const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// MySQL configuracion de conecxion
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'tothush'
});

connection.connect(err => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL');
});

// recuperar data
app.get('/api/data', (req, res) => {
    connection.query('SELECT * FROM Product', (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).send('Error fetching data');
            return;
        }
        res.json(results);
    });
});

// insertar data
app.post('/api/data', (req, res) => {
    const { name, price, description } = req.body;
    const query = 'INSERT INTO Product (name, price, description) VALUES (?, ?, ?)';
    connection.query(query, [name, price, description], (err, results) => {
        if (err) {
            console.error('Error inserting data:', err);
            res.status(500).send('Error inserting data');
            return;
        }
        res.status(201).send('Data inserted successfully');
    });
});

// actualizar data
app.put('/api/data/:id', (req, res) => {
    const { id } = req.params;
    const { name, price, description } = req.body;
    const query = 'UPDATE Product SET name = ?, price = ?, description = ? WHERE id = ?';
    connection.query(query, [name, price, description, id], (err, results) => {
        if (err) {
            console.error('Error updating data:', err);
            res.status(500).send('Error updating data');
            return;
        }
        res.send('Data updated successfully');
    });
});

// borrar data
app.delete('/api/data/:id', (req, res) => {
    const { id } = req.params;
    const query = 'DELETE FROM Product WHERE id = ?';
    connection.query(query, [id], (err, results) => {
        if (err) {
            console.error('Error deleting data:', err);
            res.status(500).send('Error deleting data');
            return;
        }
        res.send('Data deleted successfully');
    });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
