const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello World!');
});

// Vulnérabilité intentionnelle : Secret en dur
const apiKey = "SK-1234567890ABCDEF1234567890";

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
