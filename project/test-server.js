const express = require('express');
const app = express();
const PORT = 3000;

console.log('Starting test server...');

app.use(express.json());

app.get('/test', (req, res) => {
  res.json({ message: 'Server is working!' });
});

app.listen(PORT, () => {
  console.log(`Test server running on port ${PORT}`);
});
