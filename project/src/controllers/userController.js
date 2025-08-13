const { User } = require('../models');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
// const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
require('dotenv').config();


class UserController {
  // Generate a secure session token
  static generateSessionToken() {
    return crypto.randomBytes(32).toString('hex');
  }

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

      // Generate session token
      const sessionToken = UserController.generateSessionToken();

      // Update user with session token and last login time
      user.sessionToken = sessionToken;
      user.lastLoginAt = new Date();
      await user.save();

      const userResponse = user.toObject();
      delete userResponse.passwordHash;
      delete userResponse.sessionToken; // Don't include in user object

      res.status(200).json({
        message: 'Login successful',
        user: userResponse,
        sessionToken: sessionToken,
        expiresIn: 7 * 24 * 60 * 60 * 1000, // 7 days in milliseconds
      });
    } catch (error) {
      next(error); // Pass errors to the error-handling middleware
    }
  }

  static async validateSession(req, res, next) {
    try {
      const { userId, userRole } = req.body;
      const authHeader = req.headers.authorization;

      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
          valid: false,
          error: 'No session token provided'
        });
      }

      const sessionToken = authHeader.substring(7); // Remove 'Bearer ' prefix

      if (!userId || !sessionToken) {
        return res.status(400).json({
          valid: false,
          error: 'User ID and session token are required'
        });
      }

      // Find user with matching session token
      const user = await User.findOne({
        _id: userId,
        sessionToken: sessionToken
      });

      if (!user) {
        return res.status(401).json({
          valid: false,
          error: 'Invalid session token'
        });
      }

      // Check if user is blocked
      if (user.isBlocked) {
        return res.status(403).json({
          valid: false,
          error: 'Account has been blocked',
          status: 'blocked'
        });
      }

      // Session is valid
      res.status(200).json({
        valid: true,
        user: {
          _id: user._id,
          username: user.username,
          email: user.email,
          role: user.role,
        }
      });
    } catch (error) {
      console.error('Session validation error:', error);
      next(error);
    }
  }

  static async logout(req, res, next) {
    try {
      const { userId } = req.body;
      const authHeader = req.headers.authorization;

      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
          success: false,
          error: 'No session token provided'
        });
      }

      const sessionToken = authHeader.substring(7); // Remove 'Bearer ' prefix

      if (!userId || !sessionToken) {
        return res.status(400).json({
          success: false,
          error: 'User ID and session token are required'
        });
      }

      // Find user and clear session token
      const user = await User.findOne({
        _id: userId,
        sessionToken: sessionToken
      });

      if (user) {
        user.sessionToken = null;
        await user.save();
      }

      // Also check therapist collection
      const { Therapist } = require('../models');
      const therapist = await Therapist.findOne({
        _id: userId,
        sessionToken: sessionToken
      });

      if (therapist) {
        therapist.sessionToken = null;
        await therapist.save();
      }

      res.status(200).json({
        success: true,
        message: 'Logout successful'
      });
    } catch (error) {
      console.error('Logout error:', error);
      next(error);
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

    // Professional HTML Email Template
    const emailTemplate = `
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            background-color: #f4f4f4;
            color: #333333;
            line-height: 1.6;
          }
          .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
          }
          .header {
            background: linear-gradient(135deg, #6B73FF 0%, #9B59B6 100%);
            padding: 40px 30px;
            text-align: center;
            position: relative;
          }
          .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
          }
          .logo {
            position: relative;
            z-index: 1;
          }
          .logo h1 {
            color: #ffffff;
            margin: 0;
            font-size: 32px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
          }
          .logo p {
            color: #ffffff;
            margin: 8px 0 0 0;
            font-size: 16px;
            opacity: 0.95;
            font-weight: 300;
          }
          .content {
            padding: 50px 40px;
            text-align: center;
          }
          .content h2 {
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 20px;
            font-weight: 600;
          }
          .greeting {
            color: #34495e;
            font-size: 18px;
            margin-bottom: 25px;
            font-weight: 500;
          }
          .message {
            color: #7f8c8d;
            font-size: 16px;
            line-height: 1.8;
            margin-bottom: 30px;
          }
          .password-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px solid #6B73FF;
            border-radius: 12px;
            padding: 30px;
            margin: 30px 0;
            position: relative;
            box-shadow: 0 2px 10px rgba(107, 115, 255, 0.1);
          }
          .password-label {
            color: #6B73FF;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 15px;
          }
          .password-display {
            background-color: #ffffff;
            border: 2px dashed #6B73FF;
            border-radius: 8px;
            padding: 20px;
            font-family: 'Courier New', 'Monaco', monospace;
            font-size: 24px;
            font-weight: bold;
            color: #2c5aa0;
            letter-spacing: 3px;
            word-break: break-all;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
          }
          .security-notice {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border-left: 5px solid #f39c12;
            border-radius: 8px;
            padding: 20px;
            margin: 30px 0;
            text-align: left;
          }
          .security-notice .icon {
            font-size: 20px;
            margin-right: 10px;
          }
          .security-notice h4 {
            color: #d68910;
            margin: 0 0 10px 0;
            font-size: 16px;
            font-weight: 600;
          }
          .security-notice p {
            color: #856404;
            margin: 0;
            font-size: 14px;
            line-height: 1.5;
          }
          .action-steps {
            background-color: #e8f4fd;
            border-radius: 10px;
            padding: 25px;
            margin: 30px 0;
            text-align: left;
          }
          .action-steps h4 {
            color: #2980b9;
            margin: 0 0 15px 0;
            font-size: 16px;
            font-weight: 600;
          }
          .action-steps ol {
            color: #34495e;
            margin: 0;
            padding-left: 20px;
          }
          .action-steps li {
            margin-bottom: 8px;
            font-size: 14px;
          }
          .footer {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            padding: 40px 30px;
            text-align: center;
            color: #ecf0f1;
          }
          .footer-content {
            max-width: 400px;
            margin: 0 auto;
          }
          .support-info {
            margin-bottom: 25px;
          }
          .support-info h4 {
            color: #ffffff;
            margin: 0 0 10px 0;
            font-size: 16px;
            font-weight: 600;
          }
          .support-info p {
            margin: 5px 0;
            font-size: 14px;
            opacity: 0.9;
          }
          .support-info a {
            color: #74b9ff;
            text-decoration: none;
            font-weight: 500;
          }
          .support-info a:hover {
            text-decoration: underline;
          }
          .footer-links {
            border-top: 1px solid #4a5568;
            padding-top: 20px;
            margin-top: 20px;
          }
          .footer-links p {
            margin: 5px 0;
            font-size: 12px;
            opacity: 0.8;
          }
          .footer-links a {
            color: #74b9ff;
            text-decoration: none;
            margin: 0 10px;
          }
          .footer-links a:hover {
            text-decoration: underline;
          }
          @media only screen and (max-width: 600px) {
            .container {
              margin: 10px;
              border-radius: 8px;
            }
            .content {
              padding: 30px 25px;
            }
            .header {
              padding: 30px 20px;
            }
            .logo h1 {
              font-size: 28px;
            }
            .content h2 {
              font-size: 24px;
            }
            .password-display {
              font-size: 20px;
              letter-spacing: 2px;
              padding: 15px;
            }
            .password-card {
              padding: 20px;
            }
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <div class="logo">
              <h1>🧠 MindEase</h1>
              <p>Your Mental Wellness Companion</p>
            </div>
          </div>

          <div class="content">
            <h2>Password Reset Request</h2>
            <p class="greeting">Hello ${user.username || 'Valued User'},</p>
            <p class="message">
              We received a request to reset your MindEase account password.
              Your new temporary password has been generated and is ready for use.
            </p>

            <div class="password-card">
              <div class="password-label">Your New Temporary Password</div>
              <div class="password-display">${password}</div>
            </div>

            <div class="security-notice">
              <h4><span class="icon">🔒</span>Important Security Notice</h4>
              <p>This is a temporary password. For your account security, please log in immediately and change this password to something only you know.</p>
            </div>

            <div class="action-steps">
              <h4>📋 Next Steps:</h4>
              <ol>
                <li>Use the password above to log into your MindEase account</li>
                <li>Go to your Account Settings immediately after logging in</li>
                <li>Create a new, strong password that only you know</li>
                <li>Consider enabling two-factor authentication for extra security</li>
              </ol>
            </div>

            <p class="message">
              If you didn't request this password reset, please contact our support team immediately.
              Your account security is our top priority.
            </p>
          </div>

          <div class="footer">
            <div class="footer-content">
              <div class="support-info">
                <h4>Need Help?</h4>
                <p>Our support team is here for you 24/7</p>
                <p>📧 <a href="mailto:support@mindease.com">support@mindease.com</a></p>
                <p>📞 1-800-MINDEASE</p>
              </div>

              <div class="footer-links">
                <p>© 2025 MindEase. All rights reserved.</p>
                <p>
                  <a href="https://mindease.com/privacy">Privacy Policy</a> |
                  <a href="https://mindease.com/terms">Terms of Service</a> |
                  <a href="https://mindease.com/security">Security</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </body>
      </html>
    `;

    const mailOptions = {
      from: {
        name: 'MindEase Security Team',
        address: process.env.EMAIL_FROM || 'security@mindease.com'
      },
      to: user.email,
      subject: "🔐 Your MindEase Password Has Been Reset",
      html: emailTemplate,
      // Enhanced fallback text version
      text: `
MindEase - Password Reset

Hello ${user.username || 'Valued User'},

We received a request to reset your MindEase account password.

Your new temporary password is: ${password}

IMPORTANT SECURITY NOTICE:
This is a temporary password. For your account security, please:

1. Log into your MindEase account using this password
2. Go to Account Settings immediately after logging in
3. Create a new, strong password that only you know
4. Consider enabling two-factor authentication

If you didn't request this password reset, please contact our support team immediately at support@mindease.com or call 1-800-MINDEASE.

Your account security is our top priority.

Best regards,
MindEase Security Team

---
© 2025 MindEase. All rights reserved.
Privacy Policy: https://mindease.com/privacy
Terms of Service: https://mindease.com/terms
      `.trim()
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

  static async changePasswordById(req, res) {
    try {
      const { currentPassword, newPassword } = req.body;
      const userId = req.params.id;

      // Validate input
      if (!currentPassword || !newPassword) {
        return res
          .status(400)
          .json({ message: "Please provide both current and new passwords." });
      }

      // Find user by ID
      const user = await User.findById(userId);

      if (!user) {
        return res.status(404).json({ message: "User not found." });
      }

      // Compare the current password
      const isMatch = await bcrypt.compare(currentPassword, user.passwordHash);
      if (!isMatch) {
        return res.status(400).json({ message: "Current password is incorrect." });
      }

      // Hash the new password
      const hashedPassword = await bcrypt.hash(newPassword, 10);

      // Update the password
      user.passwordHash = hashedPassword;
      await user.save();

      res.status(200).json({ message: "Password updated successfully." });
    } catch (error) {
      console.error("Error in changePasswordById:", error);
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

  // Upload profile photo
  static async uploadProfilePhoto(req, res, next) {
    try {
      const { id } = req.params;
      const { profilePhoto } = req.body;

      if (!profilePhoto) {
        return res.status(400).json({ message: 'Profile photo data is required' });
      }

      const user = await User.findById(id);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      user.profilePhoto = profilePhoto;
      await user.save();

      res.json({
        message: 'Profile photo updated successfully',
        profilePhoto: user.profilePhoto
      });
    } catch (error) {
      next(error);
    }
  }

  // Get user profile with photo
  static async getUserProfile(req, res, next) {
    try {
      const { id } = req.params;

      const user = await User.findById(id).select('-passwordHash');
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      res.json(user);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = UserController;

