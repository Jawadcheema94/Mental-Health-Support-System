const express = require('express');
const router = express.Router();
const MedicationController = require('../controllers/medicationController');

// Get all medications for a user
router.get('/user/:userId', MedicationController.getUserMedications);

// Get specific medication by ID
router.get('/:id', MedicationController.getMedicationById);

// Therapist prescribes medication to user
router.post('/prescribe', MedicationController.prescribeMedication);

// Update medication
router.put('/:id', MedicationController.updateMedication);

// Delete medication
router.delete('/:id', MedicationController.deleteMedication);

// Log medication intake
router.post('/:id/log', MedicationController.logMedicationIntake);

// Get medication logs for date range
router.get('/user/:userId/logs', MedicationController.getMedicationLogs);

// Toggle medication active status
router.put('/:id/toggle', MedicationController.toggleMedicationStatus);

// Get today's medication schedule
router.get('/user/:userId/today', MedicationController.getTodaySchedule);

module.exports = router;
