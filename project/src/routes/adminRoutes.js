const express = require('express');
const router = express.Router();
const AdminController = require('../controllers/adminController');

// Admin authentication
router.post('/login', AdminController.login);

// Admin dashboard stats
router.get('/stats', AdminController.getDashboardStats);

module.exports = router;
