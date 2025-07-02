// const { JournalEntry, User } = require('../models');
// const { getUserById } = require('./userController');

// class JournalController {
//   static async getAllEntries(req, res, next) {
//     try {
//       const entries = await JournalEntry.find().populate('userId', '-passwordHash');
//       res.json(entries);
//     } catch (error) {
//       next(error);
//     }
//   }

//   static async getEntryById(req, res, next) {
//     try {
//       const entry = await JournalEntry.findById(req.params.id)
//         .populate('userId', '-passwordHash');
      
//       if (!entry) {
//         return res.status(404).json({ message: 'Journal entry not found' });
//       }
      
//       res.json(entry);
//     } catch (error) {
//       next(error);
//     }
//   }

//   static async createEntry(req, res, next) {
//     try {
//       const user = await getUserById(req.body.userId);
//       if (!user) return res.status(404).json({ message: "User not found" });
  
//       const entry = new JournalEntry({
//         userId: req.body.userId,
//         entryDate: req.body.date,  // Ensure date is properly set
//         content: req.body.entry,   // Use 'content' instead of 'entry'
//         sentimentScore: req.body.sentimentScore || 0, // Default sentiment score
//       });
  
//       const newEntry = await entry.save();
  
//       // Update user's mood entries
//       await User.findByIdAndUpdate(req.body.userId, {
//         $push: {
//           moodEntries: {
//             date: entry.entryDate,
//             mood: req.body.mood || 'neutral', // Ensure 'mood' is defined
//             journalEntryId: entry._id,
//           },
//         },
//       });
  
//       res.status(201).json(newEntry);
//     } catch (error) {
//       next(error);
//     }
//   }
  

//   static async updateEntry(req, res, next) {
//     try {
//       const { content, mood } = req.body;
      
//       const entry = await JournalEntry.findByIdAndUpdate(
//         req.params.id,
//         { content, mood },
//         { new: true }
//       );

//       if (!entry) {
//         return res.status(404).json({ message: 'Journal entry not found' });
//       }

//       res.json(entry);
//     } catch (error) {
//       next(error);
//     }
//   }

//   static async deleteEntry(req, res, next) {
//     try {
//       const entry = await JournalEntry.findByIdAndDelete(req.params.id);
      
//       if (!entry) {
//         return res.status(404).json({ message: 'Journal entry not found' });
//       }

//       // Remove reference from user's mood entries
//       await User.updateOne(
//         { _id: entry.userId },
//         { $pull: { moodEntries: { journalEntryId: entry._id } } }
//       );

//       res.json({ message: 'Journal entry deleted successfully' });
//     } catch (error) {
//       next(error);
//     }
//   }
// }

// module.exports = JournalController;

const { JournalEntry, User } = require('../models');
const { getUserById } = require('./userController');

class JournalController {
  static async getAllEntries(req, res, next) {
    try {
      const entries = await JournalEntry.find().populate('userId', '-passwordHash');
      res.json(entries);
    } catch (error) {
      next(error);
    }
  }

  static async getEntryById(req, res, next) {
    try {
      const entry = await JournalEntry.findById(req.params.id)
        .populate('userId', '-passwordHash');
      
      if (!entry) return res.status(404).json({ message: 'Journal entry not found' });
      
      res.json(entry);
    } catch (error) {
      next(error);
    }
  } 

  // static async createEntry(req, res, next) {
  //   try {
  //     const user = await getUserById(req.body.userId);
  //     if (!user) return res.status(404).json({ message: "User not found" });

  //     const entry = new JournalEntry({
  //       userId: req.body.userId,
  //       entryDate: req.body.date,
  //       content: req.body.entry,
  //       sentimentScore: req.body.sentimentScore || 0,
  //     });

  //     const newEntry = await entry.save();

  //     await User.findByIdAndUpdate(req.body.userId, {
  //       $push: {
  //         moodEntries: {
  //           date: entry.entryDate,
  //           mood: req.body.mood || 'neutral',
  //           journalEntryId: entry._id,
  //         },
  //       },
  //     });

  //     res.status(201).json(newEntry);
  //   } catch (error) {
  //     next(error);
  //   }
  // }


  static async createEntry(req, res, next) {
    try {
      // Validate user
      const user = await User.findById(req.body.userId);
      if (!user) return res.status(404).json({ message: "User not found" });
  
      // Create new journal entry
      const entry = new JournalEntry({
        userId: req.body.userId,
        entryDate: req.body.date, // ISO string or Date object
        content: req.body.content, // ✅ use 'content' to match schema
        sentimentScore: req.body.sentimentScore || 0,
      });
  
      const newEntry = await entry.save();
  
      // Update moodEntries array in User document
      await User.findByIdAndUpdate(req.body.userId, {
        $push: {
          moodEntries: { 
            date: entry.entryDate,
            mood: req.body.mood || 'neutral',
            journalEntryId: entry._id,
          },
        },
      });
  
      res.status(201).json(newEntry);
    } catch (error) {
      console.error('Create Journal Entry Error:', error.message);
      next(error);
    }
  }
  
  static async updateEntry(req, res, next) {
    try {
      const { content, mood } = req.body;
      const entry = await JournalEntry.findByIdAndUpdate(req.params.id, { content, mood }, { new: true });

      if (!entry) return res.status(404).json({ message: 'Journal entry not found' });

      res.json(entry);
    } catch (error) {
      next(error);
    }
  }

  static async deleteEntry(req, res, next) {
    try {
      const entry = await JournalEntry.findByIdAndDelete(req.params.id);
      if (!entry) return res.status(404).json({ message: 'Journal entry not found' });

      await User.updateOne({ _id: entry.userId }, { $pull: { moodEntries: { journalEntryId: entry._id } } });

      res.json({ message: 'Journal entry deleted successfully' });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = JournalController;
