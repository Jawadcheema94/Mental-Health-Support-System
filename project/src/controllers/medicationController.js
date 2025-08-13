const { Medication, User } = require('../models');

class MedicationController {
  // Get all medications for a user
  static async getUserMedications(req, res, next) {
    try {
      const { userId } = req.params;
      
      const medications = await Medication.find({ userId }).sort({ createdAt: -1 });
      res.json(medications);
    } catch (error) {
      next(error);
    }
  }

  // Get specific medication by ID
  static async getMedicationById(req, res, next) {
    try {
      const { id } = req.params;
      
      const medication = await Medication.findById(id);
      if (!medication) {
        return res.status(404).json({ message: 'Medication not found' });
      }
      
      res.json(medication);
    } catch (error) {
      next(error);
    }
  }

  // Add new medication (therapist prescribes to user)
  static async prescribeMedication(req, res, next) {
    try {
      const { userId, therapistId, name, dosage, frequency, instructions, startDate, endDate, reminders } = req.body;

      // Validate required fields
      if (!userId || !therapistId || !name || !dosage || !frequency || !startDate) {
        return res.status(400).json({
          message: 'userId, therapistId, name, dosage, frequency, and startDate are required'
        });
      }

      // Check if user exists
      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      // Check if therapist exists
      const { Therapist } = require('../models');
      const therapist = await Therapist.findById(therapistId);
      if (!therapist) {
        return res.status(404).json({ message: 'Therapist not found' });
      }

      const medication = new Medication({
        userId,
        therapistId,
        name,
        dosage,
        frequency,
        instructions,
        prescribedBy: therapist.username || therapist.name,
        startDate: new Date(startDate),
        endDate: endDate ? new Date(endDate) : null,
        reminders: reminders || [],
        isActive: true,
        prescriptionDate: new Date()
      });

      await medication.save();
      res.status(201).json(medication);
    } catch (error) {
      next(error);
    }
  }

  // Update medication
  static async updateMedication(req, res, next) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      
      const medication = await Medication.findById(id);
      if (!medication) {
        return res.status(404).json({ message: 'Medication not found' });
      }

      // Update fields
      Object.keys(updateData).forEach(key => {
        if (key !== '_id' && key !== 'userId' && key !== 'createdAt') {
          medication[key] = updateData[key];
        }
      });

      medication.updatedAt = new Date();
      await medication.save();
      
      res.json(medication);
    } catch (error) {
      next(error);
    }
  }

  // Delete medication
  static async deleteMedication(req, res, next) {
    try {
      const { id } = req.params;
      
      const medication = await Medication.findByIdAndDelete(id);
      if (!medication) {
        return res.status(404).json({ message: 'Medication not found' });
      }
      
      res.json({ message: 'Medication deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  // Log medication intake
  static async logMedicationIntake(req, res, next) {
    try {
      const { id } = req.params;
      const { taken, notes, date } = req.body;
      
      const medication = await Medication.findById(id);
      if (!medication) {
        return res.status(404).json({ message: 'Medication not found' });
      }

      // Add log entry
      medication.logs.push({
        date: date ? new Date(date) : new Date(),
        taken: taken === true,
        notes: notes || ''
      });

      medication.updatedAt = new Date();
      await medication.save();
      
      res.json(medication);
    } catch (error) {
      next(error);
    }
  }

  // Get medication logs for a specific date range
  static async getMedicationLogs(req, res, next) {
    try {
      const { userId } = req.params;
      const { startDate, endDate } = req.query;
      
      const start = startDate ? new Date(startDate) : new Date(Date.now() - 30 * 24 * 60 * 60 * 1000); // Default: last 30 days
      const end = endDate ? new Date(endDate) : new Date();
      
      const medications = await Medication.find({ 
        userId,
        'logs.date': {
          $gte: start,
          $lte: end
        }
      });

      // Extract logs within date range
      const logs = [];
      medications.forEach(medication => {
        medication.logs.forEach(log => {
          if (log.date >= start && log.date <= end) {
            logs.push({
              medicationId: medication._id,
              medicationName: medication.name,
              dosage: medication.dosage,
              date: log.date,
              taken: log.taken,
              notes: log.notes
            });
          }
        });
      });

      // Sort by date (most recent first)
      logs.sort((a, b) => new Date(b.date) - new Date(a.date));
      
      res.json(logs);
    } catch (error) {
      next(error);
    }
  }

  // Toggle medication active status
  static async toggleMedicationStatus(req, res, next) {
    try {
      const { id } = req.params;
      
      const medication = await Medication.findById(id);
      if (!medication) {
        return res.status(404).json({ message: 'Medication not found' });
      }

      medication.isActive = !medication.isActive;
      medication.updatedAt = new Date();
      await medication.save();
      
      res.json(medication);
    } catch (error) {
      next(error);
    }
  }

  // Get today's medication schedule
  static async getTodaySchedule(req, res, next) {
    try {
      const { userId } = req.params;
      
      const medications = await Medication.find({ 
        userId, 
        isActive: true 
      });

      const today = new Date();
      const todayString = today.toISOString().split('T')[0];

      const schedule = [];
      medications.forEach(medication => {
        medication.reminders.forEach(reminder => {
          if (reminder.enabled) {
            // Check if already taken today
            const todayLog = medication.logs.find(log => 
              log.date.toISOString().split('T')[0] === todayString
            );

            schedule.push({
              medicationId: medication._id,
              medicationName: medication.name,
              dosage: medication.dosage,
              time: reminder.time,
              taken: todayLog ? todayLog.taken : false,
              instructions: medication.instructions
            });
          }
        });
      });

      // Sort by time
      schedule.sort((a, b) => a.time.localeCompare(b.time));
      
      res.json(schedule);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = MedicationController;
