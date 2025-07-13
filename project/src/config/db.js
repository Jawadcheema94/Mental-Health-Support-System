const mongoose = require('mongoose');

const connectDB = async () => {
  console.log('🔄 Connecting to Local MongoDB...');

  try {
    // Local MongoDB connection string with existing database name
    const mongoURI = 'mongodb+srv://mindease:GURJDSU$&$JDG@mindease.fvud7n2.mongodb.net/?retryWrites=true&w=majority&appName=Mindease';

    console.log('📡 Connecting to your local MongoDB instance...');
    await mongoose.connect(mongoURI);

    console.log('✅ Local MongoDB connected successfully!');
    console.log('🌐 Using local database: mindease');

    // Test the connection
    const db = mongoose.connection.db;
    await db.admin().ping();
    console.log('🏓 MongoDB ping successful - Database is ready!');

    // Create indexes for better performance
    await createIndexes();

    // Create initial admin user if not exists
    await createInitialData();

    console.log('🚀 Database setup completed - Ready for real-time operations!');

  } catch (error) {
    console.error('❌ Local MongoDB connection failed:', error.message);
    console.log('💡 Please ensure MongoDB is running on 192.168.2.105:27017');
    console.log('🔧 Troubleshooting:');
    console.log('   1. Start MongoDB service: net start MongoDB (as admin)');
    console.log('   2. Or run: mongod --dbpath "C:\\data\\db"');
    console.log('   3. Check if port 27017 is available');
    console.log('   4. Verify MongoDB is installed correctly');

    // Try to start MongoDB service automatically
    console.log('🔧 Attempting to start MongoDB service...');
    await startMongoDBService();
    process.exit(1);
  }
};

// Try to start MongoDB service
const startMongoDBService = async () => {
  const { exec } = require('child_process');
  const util = require('util');
  const execPromise = util.promisify(exec);

  try {
    console.log('🔧 Attempting to start MongoDB service...');

    // Try different ways to start MongoDB
    const commands = [
      'net start MongoDB',
      'brew services start mongodb-community',
      'sudo systemctl start mongod',
      'mongod --dbpath "C:\\data\\db"'
    ];

    for (const command of commands) {
      try {
        console.log(`🔧 Trying: ${command}`);
        await execPromise(command);
        console.log('✅ MongoDB service started successfully!');
        await new Promise(resolve => setTimeout(resolve, 3000)); // Wait 3 seconds
        return;
      } catch (cmdError) {
        console.log(`❌ Command failed: ${command}`);
      }
    }

    console.log('⚠️ Could not start MongoDB service automatically');
  } catch (error) {
    console.log('⚠️ Error starting MongoDB service:', error.message);
  }
};

// Create database indexes for better performance
const createIndexes = async () => {
  try {
    const db = mongoose.connection.db;

    // Create indexes for users collection
    await db.collection('users').createIndex({ email: 1 }, { unique: true });
    await db.collection('users').createIndex({ role: 1 });
    await db.collection('users').createIndex({ isBlocked: 1 });

    // Create indexes for therapists collection
    await db.collection('therapists').createIndex({ email: 1 }, { unique: true });
    await db.collection('therapists').createIndex({ isApproved: 1 });
    await db.collection('therapists').createIndex({ isBlocked: 1 });

    // Create indexes for journal entries
    await db.collection('journalentries').createIndex({ userId: 1 });
    await db.collection('journalentries').createIndex({ entryDate: -1 });

    console.log('📊 Database indexes created successfully');
  } catch (error) {
    console.log('⚠️ Index creation warning:', error.message);
  }
};

// Create initial data for testing
const createInitialData = async () => {
  try {
    const { User, Therapist } = require('../models');
    const bcrypt = require('bcryptjs');

    // Check if admin user exists
    const adminExists = await User.findOne({ email: 'admin@mentalhealth.com' });
    if (!adminExists) {
      const hashedPassword = await bcrypt.hash('admin123', 10);
      await User.create({
        username: 'admin',
        email: 'admin@mentalhealth.com',
        passwordHash: hashedPassword,
        role: 'admin',
        isBlocked: false,
        isActive: true,
      });
      console.log('👤 Admin user created: admin@mentalhealth.com / admin123');
    }

    // Check if test user exists
    const userExists = await User.findOne({ email: 'hadyy@gmail.com' });
    if (!userExists) {
      const hashedPassword = await bcrypt.hash('password123', 10);
      await User.create({
        username: 'hadyy',
        email: 'hadyy@gmail.com',
        passwordHash: hashedPassword,
        role: 'user',
        isBlocked: false,
        isActive: true,
      });
      console.log('👤 Test user created: hadyy@gmail.com / password123');
    }

    // Check if test therapist exists
    const therapistExists = await Therapist.findOne({ email: 'sarah@therapy.com' });
    if (!therapistExists) {
      const hashedPassword = await bcrypt.hash('therapist123', 10);
      await Therapist.create({
        name: 'Dr. Sarah Johnson',
        email: 'sarah@therapy.com',
        passwordHash: hashedPassword,
        phone: '+1-555-0123',
        specialty: 'Anxiety & Depression',
        experience: 8,
        location: 'San Francisco, CA',
        coordinates: {
          type: 'Point',
          coordinates: [-122.4194, 37.7749] // [longitude, latitude] for San Francisco
        },
        rating: 4.8,
        hourlyRate: 120,
        bio: 'Specialized in cognitive behavioral therapy with 8 years of experience.',
        isApproved: false, // Needs admin approval
        isBlocked: false,
      });
      console.log('👩‍⚕️ Test therapist created: sarah@therapy.com / therapist123 (pending approval)');
    }

    console.log('✅ Initial data setup completed');
  } catch (error) {
    console.log('⚠️ Initial data creation warning:', error.message);
  }
};

// Handle connection events
mongoose.connection.on('connected', () => {
  console.log('🔗 Mongoose connected to MongoDB');
});

mongoose.connection.on('error', (err) => {
  console.error('🔥 Mongoose connection error:', err);
});

mongoose.connection.on('disconnected', () => {
  console.log('📡 Mongoose disconnected from MongoDB');
});

// Graceful shutdown
process.on('SIGINT', async () => {
  await mongoose.connection.close();
  console.log('🛑 MongoDB connection closed through app termination');
  process.exit(0);
});

module.exports = connectDB;
