// const mongoose = require('mongoose');

// const UserSchema = new mongoose.Schema({
//   username: { type: String, lowercase: true, required: true, unique: true },
//   email: { type: String, required: true, unique: true },
//   passwordHash: { type: String, required: true },

//   location: {
//     type: {
//       type: String,
//       enum: ['Point'],
//       default: 'Point',
//       required: true
//     },
//     coordinates: {
//       type: [Number],
//       default: [0, 0],
//       required: true
//     }
//   },

//   moodEntries: [
//     {
//       date: { type: Date, required: true },
//       mood: { type: String, required: true },
//       journalEntryId: { type: mongoose.Schema.Types.ObjectId, ref: 'JournalEntry' },
//     },
//   ],

//   recommendations: [
//     {
//       recommendationId: { type: mongoose.Schema.Types.ObjectId, required: true },
//       recommendationText: { type: String, required: true },
//       date: { type: Date, required: true },
//     },
//   ],

//   therapistId: { type: mongoose.Schema.Types.ObjectId, ref: 'Therapist' },
//   paymentIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Payment' }],

//   role: { type: String, enum: ['user', 'therapist', 'admin'], required: true },
// });

// UserSchema.index({ location: '2dsphere' });

// module.exports = mongoose.model('User', UserSchema);
