
// User Schema
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  username: { type: String, lowercase: true, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  passwordHash: { type: String, required: true },
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      default: [0, 0]
    }
  },
  moodEntries: [
    {
      date: { type: Date, required: true },
      mood: { type: String, required: true },
      journalEntryId: { type: mongoose.Schema.Types.ObjectId, ref: 'JournalEntry' },
    },
  ],
  recommendations: [
    {
      recommendationId: { type: mongoose.Schema.Types.ObjectId, required: true },
      recommendationText: { type: String, required: true },
      date: { type: Date, required: true },
    },
  ],
  therapistId: { type: mongoose.Schema.Types.ObjectId, ref: 'Therapist' },
  paymentIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Payment' }],
  role: { type: String, enum: ['user', 'therapist', 'admin'], required: true },
});

// Create 2dsphere index for geospatial queries
UserSchema.index({ location: "2dsphere" });



// Journal Entry Schema
const JournalEntrySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  entryDate: { type: Date, required: true },
  content: { type: String, required: true },
  sentimentScore: { type: Number, required: true },
});

// Payment Schema
const PaymentSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  amount: { type: Number, required: true },
  paymentDate: { type: Date, required: true },
  transactionStatus: { type: String, enum: ['Pending', 'Completed', 'Failed'], required: true },
});

// Therapist Schema
const TherapistSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, required: true },
  specialty: { type: String, required: true },
  experience: { type: Number, required: true },
  location: { type: String, required: true },
  coordinates: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true
    }
  },
  rating: { type: Number, default: 4.5 },
  hourlyRate: { type: Number, required: true },
  availability: [{
    day: String,
    startTime: String,
    endTime: String
  }],
  bio: { type: String, required: true },
  profileImage: { type: String, default: 'assets/images/user.png' },
  isAvailable: { type: Boolean, default: true },
  languages: [String],
  education: [String],
  certifications: [String],
  passwordHash: { type: String },
  userIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
}, {
  timestamps: true
});

// Create 2dsphere index for geospatial queries
TherapistSchema.index({ coordinates: "2dsphere" });

const moodSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  mood: { type: String, required: true },
  note: { type: String },
  date: { type: Date, default: Date.now },
});

const AppointmentSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  therapistId: { type: mongoose.Schema.Types.ObjectId, ref: 'Therapist', required: true },
  appointmentDate: { type: Date, required: true },
  duration: { type: Number, required: true }, // Duration in minutes
  status: {
    type: String,
    enum: ['scheduled', 'completed', 'cancelled', 'rescheduled'],
    default: 'scheduled',
    required: true
  },
  type: {
    type: String,
    enum: ['online', 'physical', 'instant'],
    default: 'online',
    required: true
  },
  notes: { type: String },
  meetingLink: { type: String },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

// Export Models
module.exports = {
  User: mongoose.model('User', UserSchema),
  JournalEntry: mongoose.model('JournalEntry', JournalEntrySchema),
  Payment: mongoose.model('Payment', PaymentSchema),
  Therapist: mongoose.model('Therapist', TherapistSchema),
  Mood: mongoose.model('Mood', moodSchema),
  Appointment: mongoose.model('Appointment', AppointmentSchema),
};
