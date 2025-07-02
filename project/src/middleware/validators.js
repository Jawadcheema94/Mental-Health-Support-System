const { body, validationResult } = require('express-validator');

const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  next();
};

const validateUser = [
  body('username').trim().notEmpty().withMessage('Username is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  body('role').optional().isIn(['user', 'therapist', 'admin']).withMessage('Invalid role'),
  handleValidationErrors
];

const validateJournalEntry = [
  body('userId').notEmpty().withMessage('User ID is required'),
  body('content').trim().notEmpty().withMessage('Content is required'),
  body('mood').trim().notEmpty().withMessage('Mood is required'),
  handleValidationErrors
];

const validatePayment = [
  body('userId').notEmpty().withMessage('User ID is required'),
  body('amount').isFloat({ min: 0 }).withMessage('Valid amount is required'),
  handleValidationErrors
];

const validateTherapist = [
  body('name').trim().notEmpty().withMessage('Name is required'),
  body('specialty').trim().notEmpty().withMessage('Specialty is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  body('location').trim().notEmpty().withMessage('Location is required'),
  handleValidationErrors
];

module.exports = {
  validateUser,
  validateJournalEntry,
  validatePayment,
  validateTherapist
};