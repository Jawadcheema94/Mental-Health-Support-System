const { Therapist, User } = require('../models');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
// const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

class TherapistController {
  // Generate a secure session token
  static generateSessionToken() {
    return crypto.randomBytes(32).toString('hex');
  }

  static async getAllTherapists(req, res, next) {
    try {
      const therapists = await Therapist.find();
      res.json(therapists);
    } catch (error) {
      next(error);
    }
  }

  static async getNearbyTherapists(req, res, next) {
    try {
      const { lat, lng, radius = 10 } = req.query;

      if (!lat || !lng) {
        return res.status(400).json({
          message: 'Latitude and longitude are required',
          example: '/api/therapists/nearby?lat=37.7749&lng=-122.4194&radius=10'
        });
      }

      const latitude = parseFloat(lat);
      const longitude = parseFloat(lng);
      const radiusInKm = parseFloat(radius);

      if (isNaN(latitude) || isNaN(longitude) || isNaN(radiusInKm)) {
        return res.status(400).json({
          message: 'Invalid coordinates or radius. Must be valid numbers.'
        });
      }

      console.log(`Searching for therapists near [${longitude}, ${latitude}] within ${radiusInKm}km`);

      // MongoDB geospatial query to find nearby therapists
      // Note: MongoDB expects [longitude, latitude] order
      const nearbyTherapists = await Therapist.find({
        coordinates: {
          $near: {
            $geometry: {
              type: 'Point',
              coordinates: [longitude, latitude]
            },
            $maxDistance: radiusInKm * 1000 // Convert km to meters
          }
        },
        isApproved: true,
        isBlocked: false
      }).select('-passwordHash');

      console.log(`Found ${nearbyTherapists.length} nearby therapists`);

      res.json({
        message: 'Nearby therapists retrieved successfully',
        therapists: nearbyTherapists,
        searchCenter: { latitude, longitude },
        radiusKm: radiusInKm,
        count: nearbyTherapists.length
      });
    } catch (error) {
      console.error('Error finding nearby therapists:', error);
      next(error);
    }
  }

  static async getTherapistById(req, res, next) {
    try {
      const therapist = await Therapist.findById(req.params.id);

      if (!therapist) {
        return res.status(404).json({ message: 'Therapist not found' });
      }

      res.json(therapist);
    } catch (error) {
      next(error);
    }
  }

  static async blockTherapist(req, res, next) {
    try {
      const { id } = req.params;
      const { isBlocked } = req.body;

      const therapist = await Therapist.findByIdAndUpdate(
        id,
        { isBlocked },
        { new: true }
      );

      if (!therapist) {
        return res.status(404).json({ message: 'Therapist not found' });
      }

      res.json({
        message: `Therapist ${isBlocked ? 'blocked' : 'unblocked'} successfully`,
        therapist
      });
    } catch (error) {
      next(error);
    }
  }

  static async createTherapist(req, res, next) {
    try {
      const {
        name,
        specialty,
        location,
        email,
        password,
        phone,
        experience,
        coordinates,
        rating,
        hourlyRate,
        availability,
        bio,
        profileImage,
        isAvailable,
        languages,
        education,
        certifications
      } = req.body;

      // Validate required fields
      if (!name || !specialty || !location || !email || !phone || !experience || !coordinates || !hourlyRate || !bio) {
        console.log('Validation failed. Missing fields:', {
          name: !!name,
          specialty: !!specialty,
          location: !!location,
          email: !!email,
          phone: !!phone,
          experience: !!experience,
          coordinates: !!coordinates,
          hourlyRate: !!hourlyRate,
          bio: !!bio
        });
        return res.status(400).json({
          message: 'Required fields: name, specialty, location, email, phone, experience, coordinates, hourlyRate, bio',
          received: Object.keys(req.body)
        });
      }

      let passwordHash = null;
      if (password) {
        // Hash the password if provided
        const saltRounds = 10;
        passwordHash = await bcrypt.hash(password, saltRounds);
      }

      // Create new therapist
      const therapist = new Therapist({
        name,
        specialty,
        location,
        email,
        phone,
        experience,
        coordinates,
        rating: rating || 4.5,
        hourlyRate,
        availability: availability || [],
        bio,
        profileImage: profileImage || 'assets/images/user.png',
        isAvailable: isAvailable !== undefined ? isAvailable : true,
        languages: languages || ['English'],
        education: education || [],
        certifications: certifications || [],
        passwordHash,
        userIds: [],
      });

      await therapist.save();

      // Exclude passwordHash from response
      const therapistResponse = therapist.toObject();
      delete therapistResponse.passwordHash;

      res.status(201).json(therapistResponse);
    } catch (error) {
      next(error);
    }
  }

  // static async Therapistlogin(req, res, next) {
  //   try {
  //     const { email, password } = req.body;
  
  //     // Validate input
  //     if (!email || !password) {
  //       return res.status(400).json({ error: 'Email and password are required.' });
  //     }
  
  //     // Find therapist by email
  //     const therapist = await Therapist.findOne({ email });
  //     if (!therapist) {
  //       return res.status(401).json({ error: 'Invalid email or password.' });
  //     }
  
  //     // Verify password
  //     const isPasswordValid = await bcrypt.compare(password, therapist.passwordHash);
  //     if (!isPasswordValid) {
  //       return res.status(401).json({ error: 'Invalid email or password.' });
  //     }
  
  //     // Prepare response (exclude passwordHash)
  //     const therapistResponse = therapist.toObject();
  //     delete therapistResponse.passwordHash;
  
  //     // Optional: Add JWT token generation if needed
  //     /*
  //     const token = jwt.sign(
  //       { id: therapist._id, email: therapist.email, role: 'therapist' },
  //       process.env.JWT_SECRET,
  //       { expiresIn: '1h' }
  //     );
  //     res.status(200).json({
  //       message: 'Login successful',
  //       therapist: therapistResponse,
  //       token,
  //     });
  //     */
  
  //     res.status(200).json({
  //       message: 'Login successful',
  //       therapist: therapistResponse,
  //     });
  //   } catch (error) {
  //     next(error);
  //   }
  // }

  static async Therapistlogin(req, res, next) {
    try {
      const { email, password, role} = req.body;
      console.log("Enter");
      console.log(email);
      console.log(password);
      console.log(role);
      console.log("Exit");
      // Validate input
      if (!email || !password || !role) {
        return res.status(400).json({ error: 'Email, password, and role are required.' });
      }

      // Check role and query the appropriate model
      let userOrTherapist;
      if (role === 'therapist') {
        userOrTherapist = await Therapist.findOne({ email });

        // Check if therapist account exists
        if (!userOrTherapist) {
          return res.status(401).json({ error: 'Invalid email or password.' });
        }

        // Check if therapist is approved by admin
        if (!userOrTherapist.isApproved) {
          return res.status(403).json({
            error: 'Your therapist account is pending admin approval. Please wait for approval before logging in.',
            status: 'pending_approval'
          });
        }

        // Check if therapist is blocked
        if (userOrTherapist.isBlocked) {
          return res.status(403).json({
            error: 'Your account has been blocked. Please contact support.',
            status: 'blocked'
          });
        }

      } else if (role === 'user') {
        userOrTherapist = await User.findOne({ email });

        if (!userOrTherapist) {
          return res.status(401).json({ error: 'Invalid email or password.' });
        }

        // Check if user is blocked
        if (userOrTherapist.isBlocked) {
          return res.status(403).json({
            error: 'Your account has been blocked. Please contact support.',
            status: 'blocked'
          });
        }

      } else {
        return res.status(400).json({ error: 'Invalid role. Must be "user" or "therapist".' });
      }

      // Verify password
      const isPasswordValid = await bcrypt.compare(password, userOrTherapist.passwordHash);
      if (!isPasswordValid) {
        return res.status(401).json({ error: 'Invalid email or password.' });
      }

      // Generate session token
      const sessionToken = TherapistController.generateSessionToken();

      // Update user/therapist with session token and last login time
      userOrTherapist.sessionToken = sessionToken;
      userOrTherapist.lastLoginAt = new Date();
      await userOrTherapist.save();

      // Prepare response (exclude passwordHash and sessionToken)
      const response = userOrTherapist.toObject();
      delete response.passwordHash;
      delete response.sessionToken;

      res.status(200).json({
        message: 'Login successful',
        user: response,
        sessionToken: sessionToken,
        expiresIn: 7 * 24 * 60 * 60 * 1000, // 7 days in milliseconds
      });
    } catch (error) {
      console.error(error); // Log error for debugging
      next(error);
    }
  }

  static async updateTherapist(req, res, next) {
    try {
      const { name, specialty, location, videoLink } = req.body;
      
      const therapist = await Therapist.findByIdAndUpdate(
        req.params.id,
        { name, specialty, location, videoLink },
        { new: true }
      );

      if (!therapist) {
        return res.status(404).json({ message: 'Therapist not found' });
      }

      res.json(therapist);
    } catch (error) {
      next(error);
    }
  }

  static async deleteTherapist(req, res, next) {
    try {
      const therapist = await Therapist.findByIdAndDelete(req.params.id);
      
      if (!therapist) {
        return res.status(404).json({ message: 'Therapist not found' });
      }

      // Update users who had this therapist
      await User.updateMany(
        { therapistId: therapist._id },
        { $unset: { therapistId: "" } }
      );

      res.json({ message: 'Therapist deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  static async getTherapistUsers(req, res, next) {
    try {
      const users = await User.find({ therapistId: req.params.id })
        .select('-passwordHash');

      res.json(users);
    } catch (error) {
      next(error);
    }
  }

  // Admin approve therapist
  static async approveTherapist(req, res, next) {
    try {
      const { id } = req.params;
      const { adminId, approved, rejectionReason } = req.body;

      const updateData = {
        isApproved: approved,
        // Only set approvedBy if adminId is a valid ObjectId, otherwise set to null
        approvedBy: approved && adminId && adminId !== 'admin-user-id' ? adminId : null,
        approvedAt: approved ? new Date() : null,
        rejectionReason: approved ? null : rejectionReason,
        updatedAt: new Date()
      };

      const therapist = await Therapist.findByIdAndUpdate(
        id,
        updateData,
        { new: true }
      ).select('-passwordHash');

      if (!therapist) {
        return res.status(404).json({ message: 'Therapist not found' });
      }

      res.json({
        message: `Therapist ${approved ? 'approved' : 'rejected'} successfully`,
        therapist,
        status: approved ? 'approved' : 'rejected'
      });
    } catch (error) {
      next(error);
    }
  }

  // Get pending therapists for admin approval
  static async getPendingTherapists(req, res, next) {
    try {
      const pendingTherapists = await Therapist.find({
        isApproved: false,
        isBlocked: false
      }).select('-passwordHash').sort({ createdAt: -1 });

      res.json({
        message: 'Pending therapists retrieved successfully',
        therapists: pendingTherapists,
        count: pendingTherapists.length
      });
    } catch (error) {
      next(error);
    }
  }

  static async changePassword(req, res) {
    try {
      const { id, oldPassword, newPassword } = req.body;

      // Validate input
      if (!id || !oldPassword || !newPassword) {
        return res
          .status(400)
          .json({ message: "Please provide both old and new passwords." });
      }

      const therapistId = id;

      // Find therapist by ID
      const therapist = await Therapist.findById(therapistId);

      if (!therapist) {
        return res.status(404).json({ message: "Therapist not found." });
      }

      // Compare the old password
      const isMatch = await bcrypt.compare(oldPassword, therapist.passwordHash);
      if (!isMatch) {
        return res.status(400).json({ message: "Old password is incorrect." });
      }

      // Hash the new password
      const hashedPassword = await bcrypt.hash(newPassword, 10);

      // Update the password
      therapist.passwordHash = hashedPassword;
      await therapist.save();

      res.status(200).json({ message: "Password updated successfully." });
    } catch (error) {
      console.error("Error in changePassword:", error);
      res.status(500).json({ message: "Server error. Please try again later." });
    }
  }
}

module.exports = TherapistController;