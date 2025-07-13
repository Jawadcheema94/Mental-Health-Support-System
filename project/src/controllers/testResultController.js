const { TestResult, User, Therapist, Appointment } = require('../models');

class TestResultController {
  // Save a new test result
  static async saveTestResult(req, res, next) {
    try {
      const { userId, testType, score, maxScore, severity, responses } = req.body;

      // Validate required fields
      if (!userId || !testType || score === undefined || !maxScore || !severity || !responses) {
        return res.status(400).json({ 
          message: 'Missing required fields: userId, testType, score, maxScore, severity, responses' 
        });
      }

      // Find user to validate existence
      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      // Find all therapists who have appointments with this user
      const appointments = await Appointment.find({ 
        userId: userId,
        status: { $in: ['scheduled', 'completed'] }
      }).distinct('therapistId');

      // Create new test result
      const testResult = new TestResult({
        userId,
        testType,
        score,
        maxScore,
        severity,
        responses,
        accessibleToTherapists: appointments // Only therapists with appointments can access
      });

      const savedResult = await testResult.save();
      
      res.status(201).json({
        message: 'Test result saved successfully',
        testResult: savedResult
      });
    } catch (error) {
      next(error);
    }
  }

  // Get test results for a user (only accessible by the user themselves or their appointed therapists)
  static async getUserTestResults(req, res, next) {
    try {
      const { userId } = req.params;
      const { requesterId, requesterRole } = req.query; // Who is requesting the data

      if (!requesterId || !requesterRole) {
        return res.status(400).json({ 
          message: 'Requester ID and role are required' 
        });
      }

      // If user is requesting their own data
      if (requesterRole === 'user' && requesterId === userId) {
        const testResults = await TestResult.find({ userId })
          .sort({ testDate: -1 })
          .populate('userId', 'username email');
        
        return res.json(testResults);
      }

      // If therapist is requesting user data
      if (requesterRole === 'therapist') {
        // Check if therapist has appointments with this user
        const hasAppointment = await Appointment.findOne({
          userId: userId,
          therapistId: requesterId,
          status: { $in: ['scheduled', 'completed'] }
        });

        if (!hasAppointment) {
          return res.status(403).json({ 
            message: 'Access denied. You must have an appointment with this user to view their test results.' 
          });
        }

        // Return test results that this therapist can access
        const testResults = await TestResult.find({ 
          userId: userId,
          accessibleToTherapists: requesterId
        })
        .sort({ testDate: -1 })
        .populate('userId', 'username email');
        
        return res.json(testResults);
      }

      // Admin can access all results
      if (requesterRole === 'admin') {
        const testResults = await TestResult.find({ userId })
          .sort({ testDate: -1 })
          .populate('userId', 'username email');
        
        return res.json(testResults);
      }

      return res.status(403).json({ message: 'Access denied' });
    } catch (error) {
      next(error);
    }
  }

  // Get all test results for a therapist's patients
  static async getTherapistPatientResults(req, res, next) {
    try {
      const { therapistId } = req.params;

      // Verify therapist exists
      const therapist = await Therapist.findById(therapistId);
      if (!therapist) {
        return res.status(404).json({ message: 'Therapist not found' });
      }

      // Find all users who have appointments with this therapist
      const appointments = await Appointment.find({ 
        therapistId: therapistId,
        status: { $in: ['scheduled', 'completed'] }
      }).distinct('userId');

      // Get test results for these users that this therapist can access
      const testResults = await TestResult.find({ 
        userId: { $in: appointments },
        accessibleToTherapists: therapistId
      })
      .sort({ testDate: -1 })
      .populate('userId', 'username email');
      
      res.json(testResults);
    } catch (error) {
      next(error);
    }
  }

  // Get specific test result by ID (with access validation)
  static async getTestResultById(req, res, next) {
    try {
      const { resultId } = req.params;
      const { requesterId, requesterRole } = req.query;

      if (!requesterId || !requesterRole) {
        return res.status(400).json({ 
          message: 'Requester ID and role are required' 
        });
      }

      const testResult = await TestResult.findById(resultId)
        .populate('userId', 'username email');

      if (!testResult) {
        return res.status(404).json({ message: 'Test result not found' });
      }

      // Check access permissions
      const userId = testResult.userId._id.toString();
      
      // User can access their own results
      if (requesterRole === 'user' && requesterId === userId) {
        return res.json(testResult);
      }

      // Therapist can access if they have appointments with the user
      if (requesterRole === 'therapist') {
        if (!testResult.accessibleToTherapists.includes(requesterId)) {
          return res.status(403).json({ 
            message: 'Access denied. You must have an appointment with this user to view their test results.' 
          });
        }
        return res.json(testResult);
      }

      // Admin can access all results
      if (requesterRole === 'admin') {
        return res.json(testResult);
      }

      return res.status(403).json({ message: 'Access denied' });
    } catch (error) {
      next(error);
    }
  }

  // Delete test result (only by user themselves or admin)
  static async deleteTestResult(req, res, next) {
    try {
      const { resultId } = req.params;
      const { requesterId, requesterRole } = req.query;

      if (!requesterId || !requesterRole) {
        return res.status(400).json({ 
          message: 'Requester ID and role are required' 
        });
      }

      const testResult = await TestResult.findById(resultId);
      if (!testResult) {
        return res.status(404).json({ message: 'Test result not found' });
      }

      const userId = testResult.userId.toString();

      // Only user themselves or admin can delete
      if (requesterRole === 'user' && requesterId === userId) {
        await TestResult.findByIdAndDelete(resultId);
        return res.json({ message: 'Test result deleted successfully' });
      }

      if (requesterRole === 'admin') {
        await TestResult.findByIdAndDelete(resultId);
        return res.json({ message: 'Test result deleted successfully' });
      }

      return res.status(403).json({ message: 'Access denied. Only the user or admin can delete test results.' });
    } catch (error) {
      next(error);
    }
  }

  // Get test statistics for a user (accessible by user and their therapists)
  static async getUserTestStatistics(req, res, next) {
    try {
      const { userId } = req.params;
      const { requesterId, requesterRole } = req.query;

      if (!requesterId || !requesterRole) {
        return res.status(400).json({ 
          message: 'Requester ID and role are required' 
        });
      }

      // Validate access (same logic as getUserTestResults)
      let canAccess = false;
      
      if (requesterRole === 'user' && requesterId === userId) {
        canAccess = true;
      } else if (requesterRole === 'therapist') {
        const hasAppointment = await Appointment.findOne({
          userId: userId,
          therapistId: requesterId,
          status: { $in: ['scheduled', 'completed'] }
        });
        canAccess = !!hasAppointment;
      } else if (requesterRole === 'admin') {
        canAccess = true;
      }

      if (!canAccess) {
        return res.status(403).json({ message: 'Access denied' });
      }

      // Get statistics
      const query = requesterRole === 'therapist' 
        ? { userId: userId, accessibleToTherapists: requesterId }
        : { userId: userId };

      const testResults = await TestResult.find(query).sort({ testDate: -1 });
      
      const statistics = {
        totalTests: testResults.length,
        latestTest: testResults[0] || null,
        severityDistribution: {
          Low: testResults.filter(t => t.severity === 'Low').length,
          Mild: testResults.filter(t => t.severity === 'Mild').length,
          Moderate: testResults.filter(t => t.severity === 'Moderate').length,
          Severe: testResults.filter(t => t.severity === 'Severe').length,
        },
        averageScore: testResults.length > 0 
          ? testResults.reduce((sum, t) => sum + t.score, 0) / testResults.length 
          : 0,
        testHistory: testResults.slice(0, 10) // Last 10 tests
      };

      res.json(statistics);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = TestResultController;
