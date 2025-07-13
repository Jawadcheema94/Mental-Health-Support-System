const express = require('express');
const router = express.Router();
const AIAnalysisController = require('../controllers/aiAnalysisController');

// Analyze a specific journal entry
router.post('/analyze/:userId/:journalEntryId', AIAnalysisController.analyzeJournalEntry);

// Analyze custom text content
router.post('/analyze/:userId', AIAnalysisController.analyzeJournalEntry);

// Get user's analysis history
router.get('/history/:userId', AIAnalysisController.getUserAnalysisHistory);

// Real-time analysis endpoint for live text
router.post('/realtime/:userId', AIAnalysisController.analyzeJournalEntry);

module.exports = router;
