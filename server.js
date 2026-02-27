const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello World!');
});

// Vulnérabilité intentionnelle : Secret en dur
// CORRECTION : Secret géré via variable d'environnement
const apiKey = process.env.API_KEY || "default_safe_key";

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
