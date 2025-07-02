// appointmentRoutes.js
const express = require('express');
const router = express.Router();
const AppointmentController = require('../controllers/appointmentController');

// Get all appointments (for admin)
router.get('/', AppointmentController.getAllAppointments);

// Get all appointments for a user
router.get('/user/:userId', AppointmentController.getUserAppointments);

// Get all appointments for a therapist
router.get('/therapist/:therapistId', AppointmentController.getTherapistAppointments);

// Get specific appointment details
router.get('/:appointmentId', AppointmentController.getAppointmentById);

// Book a new appointment
router.post('/', AppointmentController.bookAppointment);

// Update appointment details
router.put('/:appointmentId', AppointmentController.updateAppointment);

// Update appointment status (for admin)
router.put('/:id', AppointmentController.updateAppointmentStatus);

// Cancel an appointment
router.put('/:appointmentId/cancel', AppointmentController.cancelAppointment);

// Get available time slots for a therapist on a specific day
router.get('/available/:therapistId/:date', AppointmentController.getAvailableTimeSlots);

// Start an instant visit/meeting
router.post('/instant-visit', AppointmentController.startInstantVisit);

module.exports = router;