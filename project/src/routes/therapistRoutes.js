const express = require('express');
const router = express.Router();
const { validateTherapist } = require('../middleware/validators');
const TherapistController = require('../controllers/therapistController');

router.get('/', TherapistController.getAllTherapists);
router.get('/nearby', TherapistController.getNearbyTherapists);
router.get('/:id', TherapistController.getTherapistById);
router.post('/',  TherapistController.createTherapist);
router.post('/login', TherapistController.Therapistlogin);
router.put('/:id', validateTherapist, TherapistController.updateTherapist);
router.put('/:id/block', TherapistController.blockTherapist);
router.delete('/:id', TherapistController.deleteTherapist);
router.get('/:id/users', TherapistController.getTherapistUsers);

// Admin approval routes
router.put('/:id/approve', TherapistController.approveTherapist);
router.get('/admin/pending', TherapistController.getPendingTherapists);

module.exports = router;