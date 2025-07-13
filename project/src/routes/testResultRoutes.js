const express = require('express');
const router = express.Router();
const TestResultController = require('../controllers/testResultController');

// Save a new test result
router.post('/', TestResultController.saveTestResult);

// Get test results for a specific user (with access validation)
router.get('/user/:userId', TestResultController.getUserTestResults);

// Get all test results for a therapist's patients
router.get('/therapist/:therapistId/patients', TestResultController.getTherapistPatientResults);

// Get specific test result by ID (with access validation)
router.get('/:resultId', TestResultController.getTestResultById);

// Delete test result (only by user themselves or admin)
router.delete('/:resultId', TestResultController.deleteTestResult);

// Get test statistics for a user
router.get('/user/:userId/statistics', TestResultController.getUserTestStatistics);

module.exports = router;
