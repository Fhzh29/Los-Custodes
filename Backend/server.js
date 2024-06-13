const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// MySQL connection configuration
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

// Function to create CRUD routes for a given table
const createCrudRoutes = (tableName) => {
    // Get all data
    app.get(`/api/${tableName}`, (req, res) => {
        connection.query(`SELECT * FROM ${tableName}`, (err, results) => {
            if (err) {
                console.error(`Error fetching data from ${tableName}:`, err);
                res.status(500).send(`Error fetching data from ${tableName}`);
                return;
            }
            res.json(results);
        });
    });

    app.get('/api/ActivityLog', (req, res) => {
        const tableName = 'ActivityLog';
        connection.query(`SELECT * FROM ${tableName}`, (err, results) => {
          if (err) {
            console.error(`Error fetching data from ${tableName}:`, err);
            res.status(500).send(`Error fetching data from ${tableName}`);
            return;
          }
          res.json(results);
        });
      });

    // Insert data
    app.post(`/api/${tableName}`, (req, res) => {
        const columns = Object.keys(req.body).join(', ');
        const values = Object.values(req.body);
        const placeholders = values.map(() => '?').join(', ');
        const query = `INSERT INTO ${tableName} (${columns}) VALUES (${placeholders})`;
        connection.query(query, values, (err, results) => {
            if (err) {
                console.error(`Error inserting data into ${tableName}:`, err);
                res.status(500).send(`Error inserting data into ${tableName}`);
                return;
            }
            res.status(201).send(`Data inserted successfully into ${tableName}`);
        });
    });
    
    // get report data
    app.post(`/api/report`, (req, res) => {
        const values = Object.values(req.body);
        const placeholders = values.map(() => '?').join(', ');
        const query = `SELECT
            S.SaleID,
            S.SaleDate,
            C.FirstName AS CustomerFirstName,
            C.LastName AS CustomerLastName,
            U.FirstName AS UserFirstName,
            U.LastName AS UserLastName,
            P.ProductName,
            P.UnitPrice,
            SD.Quantity,
            SD.Subtotal
        FROM
            Sale AS S
        INNER JOIN
            Customer AS C ON S.CustomerID = C.CustomerID
        INNER JOIN
            User AS U ON S.UserID = U.UserID
        INNER JOIN
            SaleDetail AS SD ON S.SaleID = SD.SaleID
        INNER JOIN
            Product AS P ON SD.ProductID = P.ProductID`;
        connection.query(query, values, (err, results) => {
            if (err) {
                console.error(`Error retrieving report data:`, err);
                res.status(500).send(`Error retrieving report data`);
                return;
            }
            res.status(200).json(results);
        });
    });

    // Update data
    app.put(`/api/${tableName}/:id`, (req, res) => {
        const { id } = req.params;
        const updates = Object.keys(req.body).map(key => `${key} = ?`).join(', ');
        const values = [...Object.values(req.body), id];
        const query = `UPDATE ${tableName} SET ${updates} WHERE ${tableName}ID = ?`;
        connection.query(query, values, (err, results) => {
            if (err) {
                console.error(`Error updating data in ${tableName}:`, err);
                res.status(500).send(`Error updating data in ${tableName}`);
                return;
            }
            res.send(`Data updated successfully in ${tableName}`);
        });
    });

    // Delete data
    app.delete(`/api/${tableName}/:id`, (req, res) => {
        const { id } = req.params;
        const query = `DELETE FROM ${tableName} WHERE ${tableName}ID = ?`;
        connection.query(query, [id], (err, results) => {
            if (err) {
                console.error(`Error deleting data from ${tableName}:`, err);
                res.status(500).send(`Error deleting data from ${tableName}`);
                return;
            }
            res.send(`Data deleted successfully from ${tableName}`);
        });
    });
};

// Create CRUD routes for each table
['Category', 'Customer', 'User', 'Product', 'Saledetail', 'Sale', 'Role'].forEach(createCrudRoutes);

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
