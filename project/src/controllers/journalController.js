const { JournalEntry, User } = require('../models');

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
      
      if (!entry) {
        return res.status(404).json({ message: 'Journal entry not found' });
      }
      
      res.json(entry);
    } catch (error) {
      next(error);
    }
  }

  static async createEntry(req, res, next) {
    try {
      const { userId, content, mood, tags, date } = req.body;
      
      if (!userId || !content) {
        return res.status(400).json({ message: 'userId and content are required' });
      }

      const entry = new JournalEntry({
        userId,
        entryDate: date || new Date(),
        content,
        mood: mood || 'neutral',
        tags: tags || [],
        sentimentScore: 0
      });

      const newEntry = await entry.save();

      // Update user's mood entries
      await User.findByIdAndUpdate(userId, {
        $push: {
          moodEntries: {
            date: entry.entryDate,
            mood: mood || 'neutral',
            journalEntryId: entry._id,
          },
        },
      });

      res.status(201).json(newEntry);
    } catch (error) {
      next(error);
    }
  }

  static async updateEntry(req, res, next) {
    try {
      const { content, mood } = req.body;
      
      const entry = await JournalEntry.findByIdAndUpdate(
        req.params.id,
        { content, mood },
        { new: true }
      );

      if (!entry) {
        return res.status(404).json({ message: 'Journal entry not found' });
      }

      res.json(entry);
    } catch (error) {
      next(error);
    }
  }

  static async deleteEntry(req, res, next) {
    try {
      const entry = await JournalEntry.findByIdAndDelete(req.params.id);
      
      if (!entry) {
        return res.status(404).json({ message: 'Journal entry not found' });
      }

      // Remove reference from user's mood entries
      await User.updateOne(
        { _id: entry.userId },
        { $pull: { moodEntries: { journalEntryId: entry._id } } }
      );

      res.json({ message: 'Journal entry deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  static async getEntriesByUser(req, res, next) {
    try {
      const { userId } = req.params;
      const entries = await JournalEntry.find({ userId })
        .sort({ entryDate: -1 })
        .populate('userId', '-passwordHash');
      
      res.json(entries);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = JournalController;
