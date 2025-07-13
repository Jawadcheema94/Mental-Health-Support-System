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

router.use('/users', userRoutes);
router.use('/mood', postRoutes);
router.use('/journal', journalRoutes);
router.use('/payments', paymentRoutes);
router.use('/therapists', therapistRoutes);
router.use('/appointments', appointmentRoutes);
router.use('/test-results', testResultRoutes);
router.use('/ai-analysis', aiAnalysisRoutes);
router.use('/admin', adminRoutes);

module.exports = router;