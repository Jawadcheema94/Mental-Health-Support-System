console.log('Starting test script...');

const mongoose = require('mongoose');
require('dotenv').config();

console.log('Modules loaded');

async function testConnection() {
  try {
    console.log('Attempting MongoDB connection...');
    await mongoose.connect('mongodb://localhost:27017/mindease');
    console.log('✅ Connected to MongoDB');
    
    // Test if we can access the therapists collection
    const db = mongoose.connection.db;
    const collections = await db.listCollections().toArray();
    console.log('Available collections:', collections.map(c => c.name));
    
    await mongoose.connection.close();
    console.log('Connection closed');
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

testConnection();
