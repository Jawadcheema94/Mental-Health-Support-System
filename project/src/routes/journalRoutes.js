const express = require('express');
const router = express.Router();
const { validateJournalEntry } = require('../middleware/validators');
const JournalController = require('../controllers/journalController');

router.get('/', JournalController.getAllEntries);
router.get('/:id', JournalController.getEntryById);
router.post('/create', validateJournalEntry, JournalController.createEntry);
router.put('/:id', validateJournalEntry, JournalController.updateEntry);
router.delete('/:id', JournalController.deleteEntry);

module.exports = router;

// 