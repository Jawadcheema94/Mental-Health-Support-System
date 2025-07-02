// routes/zoom.js
const express = require('express');
const router = express.Router();
const locationController = require('../controllers/locationController');

router.post('/updateLocation', locationController.updateLocation);


module.exports = router;
