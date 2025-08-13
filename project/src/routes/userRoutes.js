const express = require('express');
const router = express.Router();
const { validateUser } = require('../middleware/validators');
const UserController = require('../controllers/userController');

router.get('/', UserController.getAllUsers);
router.post('/forgot-password', UserController.forgotpassword);
router.put('/change-password', UserController.changePassword);
router.post('/changePassword', UserController.changePassword);
router.put('/:id/password', UserController.changePasswordById);
router.get('/:id', UserController.getUserById);
router.post('/signup', UserController.createUser);
router.post('/login', UserController.login);
router.put('/:id', validateUser, UserController.updateUser);
router.put('/:id/block', UserController.blockUser);
router.delete('/:id', UserController.deleteUser);
router.post('/:id/mood', UserController.addMoodEntry);
router.get('/:id/recommendations', UserController.getRecommendations);
router.post('/:id/profile-photo', UserController.uploadProfilePhoto);
router.get('/:id/profile', UserController.getUserProfile);

module.exports = router;