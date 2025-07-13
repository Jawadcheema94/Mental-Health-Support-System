const { Mood } = require('../models');

class PostController {
  static async getAllPosts(req, res, next) {
    try {
      const moods = await Mood.find().sort({ date: -1 });
      res.json(moods);
    } catch (error) {
      next(error);
    }
  }

  static async getmoodById(req, res, next) {
    try {
      const { userId } = req.params;
      console.log('Fetching moods for userId:', userId);
      const moods = await Mood.find({ userId }).sort({ date: -1 });
      console.log('Found moods:', moods.length);
      res.status(200).json(moods);
    } catch (error) {
      console.error('Error fetching moods:', error);
      next(error);
    }
  }

  static async moodentry(req, res, next) {
    try {
      const { userId, mood, note, intensity, notes } = req.body;

      if (!userId || !mood) {
        return res.status(400).json({ error: 'userId and mood are required.' });
      }

      const newMood = new Mood({
        userId,
        mood,
        note: note || notes,
        intensity: intensity || 5,
        date: new Date()
      });
      await newMood.save();
      res.status(201).json(newMood);
    } catch (error) {
      next(error);
    }
  }

  static async deletePost(req, res, next) {
    try {
      const { id } = req.params;
      const mood = await Mood.findByIdAndDelete(id);
      if (!mood) {
        return res.status(404).json({ error: 'Mood entry not found.' });
      }
      res.json({ message: `Mood entry ${id} deleted` });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = PostController;