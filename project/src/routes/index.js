const express = require('express');
const router = express.Router();
const userRoutes = require('./userRoutes');
const journalRoutes = require('./journalRoutes');
const paymentRoutes = require('./paymentRoutes');
const therapistRoutes = require('./therapistRoutes');
const postRoutes = require('./postRoutes');
const appointmentRoutes = require('./appointmentRoutes');
const testResultRoutes = require('./testResultRoutes');
const aiAnalysisRoutes = require('./aiAnalysisRoutes');
const adminRoutes = require('./adminRoutes');
const medicationRoutes = require('./medicationRoutes');
const UserController = require('../controllers/userController');

router.use('/users', userRoutes);
router.use('/mood', postRoutes);
router.use('/journal', journalRoutes);
router.use('/payments', paymentRoutes);
router.use('/therapists', therapistRoutes);
router.use('/appointments', appointmentRoutes);
router.use('/test-results', testResultRoutes);
router.use('/ai-analysis', aiAnalysisRoutes);
router.use('/admin', adminRoutes);
router.use('/medications', medicationRoutes);

// Auth routes
router.post('/auth/validate-session', UserController.validateSession);
router.post('/auth/logout', UserController.logout);

// Auth routes for admin login
router.post('/auth/admin-login', async (req, res) => {
  const { email, password } = req.body;

  // Simple admin authentication (in production, use proper authentication)
  const adminEmail = "admin@mindease.com";
  const adminPassword = "MindEase@Admin2024";

  if (email === adminEmail && password === adminPassword) {
    res.json({
      success: true,
      token: 'admin-token-' + Date.now(),
      admin: {
        email: adminEmail,
        role: 'admin'
      }
    });
  } else {
    res.status(401).json({
      success: false,
      message: 'Invalid admin credentials'
    });
  }
});

module.exports = router;