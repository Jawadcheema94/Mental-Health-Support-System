const bcrypt = require('bcryptjs');

class AdminController {
  // Simple admin login with hardcoded credentials
  // In production, this should use a proper admin user model and database
  static async login(req, res, next) {
    try {
      const { email, password } = req.body;

      // Validate input
      if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required.' });
      }

      // Hardcoded admin credentials (should be in environment variables in production)
      const ADMIN_EMAIL = 'admin@mindease.com';
      const ADMIN_PASSWORD = 'MindEase@Admin2024';

      // Check credentials
      if (email.trim().toLowerCase() !== ADMIN_EMAIL.toLowerCase()) {
        return res.status(401).json({ error: 'Invalid admin credentials.' });
      }

      if (password !== ADMIN_PASSWORD) {
        return res.status(401).json({ error: 'Invalid admin credentials.' });
      }

      // Return success response with admin data
      res.status(200).json({
        message: 'Admin login successful',
        admin: {
          _id: 'admin-001',
          name: 'System Administrator',
          email: ADMIN_EMAIL,
          role: 'admin'
        }
      });

    } catch (error) {
      console.error('Admin login error:', error);
      next(error);
    }
  }

  // Get admin dashboard stats
  static async getDashboardStats(req, res, next) {
    try {
      const { User, Therapist, Appointment } = require('../models');

      // Get counts
      const totalUsers = await User.countDocuments();
      const totalTherapists = await Therapist.countDocuments();
      const totalAppointments = await Appointment.countDocuments();
      const activeTherapists = await Therapist.countDocuments({ isApproved: true, isBlocked: false });

      // Get today's appointments
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);

      const todayAppointments = await Appointment.countDocuments({
        date: {
          $gte: today,
          $lt: tomorrow
        }
      });

      // Calculate revenue (sum of all appointment fees)
      const revenueResult = await Appointment.aggregate([
        {
          $group: {
            _id: null,
            totalRevenue: { $sum: '$fee' }
          }
        }
      ]);

      const totalRevenue = revenueResult.length > 0 ? revenueResult[0].totalRevenue : 0;

      res.json({
        totalUsers,
        totalTherapists,
        activeTherapists,
        totalAppointments,
        todayAppointments,
        totalRevenue
      });

    } catch (error) {
      console.error('Dashboard stats error:', error);
      next(error);
    }
  }
}

module.exports = AdminController;
