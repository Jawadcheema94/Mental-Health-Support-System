// Mock data service for offline mode
const { v4: uuidv4 } = require('uuid');

class MockDataService {
  constructor() {
    this.users = new Map();
    this.journalEntries = new Map();
    this.therapists = new Map();
    this.appointments = new Map();
    this.moodEntries = new Map();
    
    // Initialize with sample data
    this.initializeSampleData();
  }

  initializeSampleData() {
    // Sample users
    const sampleUsers = [
      {
        _id: '68648523e2eafc279f29e0a4',
        username: 'hadyy',
        email: 'hadyy@gmail.com',
        passwordHash: '$2a$10$hashedpassword',
        location: { type: 'Point', coordinates: [0, 0] },
        moodEntries: [],
        recommendations: [],
        paymentIds: [],
        role: 'user'
      },
      {
        _id: '68648523e2eafc279f29e0a5',
        username: 'testuser',
        email: 'test@example.com',
        passwordHash: '$2a$10$hashedpassword',
        location: { type: 'Point', coordinates: [37.7749, -122.4194] },
        moodEntries: [],
        recommendations: [],
        paymentIds: [],
        role: 'user'
      }
    ];

    sampleUsers.forEach(user => this.users.set(user._id, user));

    // Sample therapists
    const sampleTherapists = [
      {
        _id: 'therapist1',
        name: 'Dr. Sarah Johnson',
        email: 'sarah@therapy.com',
        phone: '+1-555-0123',
        specialty: 'Anxiety & Depression',
        experience: 8,
        location: 'San Francisco, CA',
        coordinates: { type: 'Point', coordinates: [37.7749, -122.4194] },
        rating: 4.8,
        hourlyRate: 120,
        bio: 'Specialized in cognitive behavioral therapy with 8 years of experience.',
        profileImage: 'assets/images/therapist1.jpg',
        isAvailable: true,
        languages: ['English', 'Spanish'],
        education: ['PhD Psychology - Stanford University'],
        certifications: ['Licensed Clinical Psychologist']
      },
      {
        _id: 'therapist2',
        name: 'Dr. Michael Chen',
        email: 'michael@therapy.com',
        phone: '+1-555-0124',
        specialty: 'Trauma & PTSD',
        experience: 12,
        location: 'New York, NY',
        coordinates: { type: 'Point', coordinates: [40.7128, -74.0060] },
        rating: 4.9,
        hourlyRate: 150,
        bio: 'Expert in trauma therapy and EMDR with over 12 years of experience.',
        profileImage: 'assets/images/therapist2.jpg',
        isAvailable: true,
        languages: ['English', 'Mandarin'],
        education: ['PhD Clinical Psychology - Columbia University'],
        certifications: ['EMDR Certified', 'Licensed Clinical Psychologist']
      }
    ];

    sampleTherapists.forEach(therapist => this.therapists.set(therapist._id, therapist));

    // Sample journal entries
    const sampleJournalEntries = [
      {
        _id: 'journal1',
        userId: '68648523e2eafc279f29e0a4',
        entryDate: new Date('2024-01-15'),
        content: 'Today I felt really anxious about my presentation at work. My heart was racing and I couldn\'t focus.',
        sentimentScore: -0.3
      },
      {
        _id: 'journal2',
        userId: '68648523e2eafc279f29e0a4',
        entryDate: new Date('2024-01-16'),
        content: 'Had a great therapy session today. Feeling more hopeful and learned some new coping strategies.',
        sentimentScore: 0.7
      }
    ];

    sampleJournalEntries.forEach(entry => this.journalEntries.set(entry._id, entry));
  }

  // User operations
  async findUserById(id) {
    return this.users.get(id) || null;
  }

  async findUserByEmail(email) {
    for (const user of this.users.values()) {
      if (user.email === email) {
        return user;
      }
    }
    return null;
  }

  async createUser(userData) {
    const id = uuidv4();
    const user = { _id: id, ...userData };
    this.users.set(id, user);
    return user;
  }

  async updateUser(id, updateData) {
    const user = this.users.get(id);
    if (user) {
      Object.assign(user, updateData);
      this.users.set(id, user);
      return user;
    }
    return null;
  }

  // Journal operations
  async findJournalEntriesByUserId(userId) {
    const entries = [];
    for (const entry of this.journalEntries.values()) {
      if (entry.userId === userId) {
        entries.push(entry);
      }
    }
    return entries.sort((a, b) => new Date(b.entryDate) - new Date(a.entryDate));
  }

  async createJournalEntry(entryData) {
    const id = uuidv4();
    const entry = { 
      _id: id, 
      entryDate: new Date(),
      sentimentScore: 0,
      ...entryData 
    };
    this.journalEntries.set(id, entry);
    return entry;
  }

  // Therapist operations
  async findAllTherapists() {
    return Array.from(this.therapists.values());
  }

  async findTherapistById(id) {
    return this.therapists.get(id) || null;
  }

  // Mood operations
  async createMoodEntry(moodData) {
    const id = uuidv4();
    const entry = { _id: id, date: new Date(), ...moodData };
    this.moodEntries.set(id, entry);
    return entry;
  }

  async findMoodEntriesByUserId(userId) {
    const entries = [];
    for (const entry of this.moodEntries.values()) {
      if (entry.userId === userId) {
        entries.push(entry);
      }
    }
    return entries.sort((a, b) => new Date(b.date) - new Date(a.date));
  }

  // Appointment operations
  async createAppointment(appointmentData) {
    const id = uuidv4();
    const appointment = { 
      _id: id, 
      createdAt: new Date(),
      updatedAt: new Date(),
      status: 'scheduled',
      ...appointmentData 
    };
    this.appointments.set(id, appointment);
    return appointment;
  }

  async findAppointmentsByUserId(userId) {
    const appointments = [];
    for (const appointment of this.appointments.values()) {
      if (appointment.userId === userId) {
        appointments.push(appointment);
      }
    }
    return appointments.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  }

  // Utility methods
  generateObjectId() {
    return uuidv4();
  }

  async ping() {
    return { ok: 1 };
  }
}

// Singleton instance
let mockDataInstance = null;

function getMockDataService() {
  if (!mockDataInstance) {
    mockDataInstance = new MockDataService();
  }
  return mockDataInstance;
}

module.exports = { MockDataService, getMockDataService };
