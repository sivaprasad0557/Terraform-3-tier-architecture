const express = require("express");
const cors = require("cors");
const mysql = require("mysql2");

const app = express();
const PORT = 5000;

app.use(cors());
app.use(express.json());

// MySQL Database Connection
const connection = mysql.createConnection({
    host: "172.31.25.147",   // Database EC2 Private IP
    user: "appuser",
    password: "P@ssword",
    database: "appdb",
    connectTimeout: 10000
});

// Connect to MySQL
connection.connect((err) => {
    if (err) {
        console.error("❌ Database connection failed:");
        console.error(err);
        return;
    }
    console.log("✅ Connected to MySQL Database");
});

// Home Route
app.get("/", (req, res) => {
    res.send("Recipe Backend Running");
});

// Get All Recipes
app.get("/api/recipes", (req, res) => {
    connection.query("SELECT * FROM recipes", (err, results) => {
        if (err) {
            console.error("Database Query Error:", err);
            return res.status(500).json({
                success: false,
                message: "Database Error",
                error: err.message
            });
        }

        res.json(results);
    });
});

// Start Server
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});
