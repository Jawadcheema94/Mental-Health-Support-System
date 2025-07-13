const { User } = require('../models');
const bcrypt = require('bcryptjs');
// const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
require('dotenv').config();


class UserController {
  static async getAllUsers(req, res, next) {
    try {
      const users = await User.find().select('-passwordHash');
      res.json(users);
    } catch (error) {
      next(error);
    }
  }

  static async getUserById(req, res, next) {
    try {
      const user = await User.findById(req.params.id)
        .select('-passwordHash')
        .populate('therapistId')
        .populate('paymentIds');

      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      res.json(user);
    } catch (error) {
      next(error);
    }
  }

  static async blockUser(req, res, next) {
    try {
      const { id } = req.params;
      const { isBlocked } = req.body;

      const user = await User.findByIdAndUpdate(
        id,
        { isBlocked },
        { new: true }
      ).select('-passwordHash');

      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      res.json({
        message: `User ${isBlocked ? 'blocked' : 'unblocked'} successfully`,
        user
      });
    } catch (error) {
      next(error);
    }
  }
  
  static async createUser(req, res, next) {
    try {
      const { username, email, password, role } = req.body;
  
      // Check if the user already exists
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ error: "A user with this email already exists." });
      }
  
      // Hash the password
      const passwordHash = await bcrypt.hash(password, 10);
  
      // Create the new user
      const user = new User({
        username,
        email,
        passwordHash,
        role: role || 'user',
        moodEntries: [],
        recommendations: [],
      });
  
      // Save the user to the database
      await user.save();
  
      // Prepare the response
      const userResponse = user.toObject();
      delete userResponse.passwordHash;
  
      res.status(201).json(userResponse);
    } catch (error) {
      next(error);
    }
  }
  
  static async login(req, res, next) {
    try {
      const { email, password } = req.body;
      // console.log("Tet");
      console.log(req.body);
      // Validate input
      if ( email == null || password == null) {
        console.log("Testt")
        console.log(email);
        console.log(password);
        return res.status(400).json({ error: 'Email and password are required.' });
      }

      const user = await User.findOne({ email });
      if (!user) {
        return res.status(401).json({ error: 'Invalid email or password.' });
      }

      // Check if user is blocked
      if (user.isBlocked) {
        return res.status(403).json({
          error: 'Your account has been blocked. Please contact support.',
          status: 'blocked'
        });
      }

      const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
      if (!isPasswordValid) {
        return res.status(401).json({ error: 'Invalid email or password.' });
      }

      const userResponse = user.toObject();
      delete userResponse.passwordHash;

      res.status(200).json({
        message: 'Login successful',
        user: userResponse,

      });
    } catch (error) {
      next(error); // Pass errors to the error-handling middleware
    }
  }

  // static async forgotpassword(req, res){
  //     try {
  //       const { email } = req.body;
    
        
  //       const user =
  //         await User.findOne({ email });
          
    
  //       if (!user) {
  //         return res.status(404).json({ message: "User not found" });
  //       }
           
  //       const newPassword = Math.random().toString(36).slice(-8);
    
  //       // const salt = await bcrypt.genSalt(10);
  //       const hashedPassword = await bcrypt.hash(newPassword,10);
    
  //       // Update user's password in the database
  //       // user.hashedPassword = hashedPassword;
  //       user.passwordHash = hashedPassword;

  //       await user.save();

  //       console.log("process.env.SMTP_HOST", process.env.SMTP_HOST);
  //       console.log("process.env.SMTP_PORT", process.env.SMTP_PORT);
  //       console.log("process.env.SMTP_USER", process.env.SMTP_USER);
  //       console.log("process.env.SMTP_PASS", process.env.SMTP_PASS);
  //       console.log("process.env.EMAIL_FROM", process.env.EMAIL_FROM);
        
    
  //       // Create a transporter using SMTP
  //       const transporter = nodemailer.createTransport({
  //         host: process.env.SMTP_HOST,
  //         port: process.env.SMTP_PORT,
  //         auth: {
  //           user: process.env.SMTP_USER,
  //           pass: process.env.SMTP_PASS,
  //         },
  //       });
    
  //       // Create email content
  //       const mailOptions = {
  //         from: process.env.EMAIL_FROM,
  //         to: user.email,
  //         subject: "Forgot Password",
  //         text: `Your new password is: ${newPassword}\nPlease change it after logging in. \n\nRegards, \nMindEase Team.`,
  //       };
    
  //       // Send the email
  //       await transporter.sendMail(mailOptions);
    
  //       res.status(200).json({ message: "New password sent to your email" });
  //     } catch (error) {
  //       console.error(error);
  //       res.status(500).json({ message: "Error in forgot password process" });
  //     }
  //   }
// adjust path if needed

static async forgotpassword(req, res) {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const password = Math.random().toString(36).slice(-8);
    const hashedPassword = await bcrypt.hash(password, 10);

    user.passwordHash = hashedPassword;  // Make sure this field matches your User schema

    await user.save();

    const transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: Number(process.env.SMTP_PORT),
      secure: Number(process.env.SMTP_PORT) === 465, // true if using port 465
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,
      },
    });

    const mailOptions = {
      from: process.env.EMAIL_FROM,
      to: user.email,
      subject: "Forgot Password",
      text: `Your new password is: ${password}\nPlease change it after logging in.\n\nRegards,\nMindEase Team.`,
    };

    await transporter.sendMail(mailOptions);

    res.status(200).json({ message: "New password sent to your email" });
  } catch (error) {
    console.error("Forgot Password Error:", error.message);
    console.error(error.stack);
    res.status(500).json({ message: "Error in forgot password process" });
  }
}
 static async changePassword (req, res)  {
  try {
    const {id, oldPassword, newPassword } = req.body;

    // Validate input
    if (!id || !oldPassword || !newPassword) {
      return res
        .status(400)
        .json({ message: "Please provide both old and new passwords." });
    }

    const userId = id; // Assuming user ID is available in `req.user` after authentication middleware.

    // Find user by ID
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }

    // Compare the old password
    const isMatch = await bcrypt.compare(oldPassword, user.passwordHash); // Use `passwordHash` field
    if (!isMatch) {
      return res.status(400).json({ message: "Old password is incorrect." });
    }

    // Hash the new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update the password
    user.passwordHash = hashedPassword;
    await user.save();

    res.status(200).json({ message: "Password updated successfully." });
  } catch (error) {
    console.error("Error in changePassword:", error);
    res.status(500).json({ message: "Server error. Please try again later." });
  }
}

  static async updateUser(req, res, next) {
    try {
      const { username, email, role } = req.body;
      
      const user = await User.findByIdAndUpdate(
        req.params.id,
        { username, email, role },
        { new: true }
      ).select('-passwordHash');

      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      res.json(user);
    } catch (error) {
      next(error);
    }
  }

  static async deleteUser(req, res, next) {
    try {
      const user = await User.findByIdAndDelete(req.params.id);
      
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      res.json({ message: 'User deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  static async addMoodEntry(req, res, next) {
    try {
      const { mood, date } = req.body;
      
      const user = await User.findById(req.params.id);
      
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      user.moodEntries.push({ mood, date: date || new Date() });
      await user.save();

      res.json(user.moodEntries);
    } catch (error) {
      next(error);
    }
  }

  static async getRecommendations(req, res, next) {
    try {
      const user = await User.findById(req.params.id);
      
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      res.json(user.recommendations);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = UserController;

