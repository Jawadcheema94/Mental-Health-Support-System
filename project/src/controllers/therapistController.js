const { Therapist, User } = require('../models');
const bcrypt = require('bcryptjs');
// const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

class TherapistController {
  static async getAllTherapists(req, res, next) {
    try {
      const therapists = await Therapist.find();
      res.json(therapists);
    } catch (error) {
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
      } else if (role === 'user') {
        userOrTherapist = await User.findOne({ email });
      } else {
        return res.status(400).json({ error: 'Invalid role. Must be "user" or "therapist".' });
      }

      // Check if user/therapist exists
      if (!userOrTherapist) {
        return res.status(401).json({ error: 'Invalid email or password.' });
      }

      // Verify password
      const isPasswordValid = await bcrypt.compare(password, userOrTherapist.passwordHash);
      if (!isPasswordValid) {
        return res.status(401).json({ error: 'Invalid email or password.' });
      }

      // Prepare response (exclude passwordHash)
      const response = userOrTherapist.toObject();
      delete response.passwordHash;

      res.status(200).json({
        message: 'Login successful',
        user: response,
        // token,
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
}

module.exports = TherapistController;