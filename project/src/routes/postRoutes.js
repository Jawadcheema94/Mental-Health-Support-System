const express = require('express');
const router = express.Router();
const { validatePost } = require('../middleware/validators');
const PostController = require('../controllers/postController');

router.get('/', PostController.getAllPosts);
router.get('/:id', PostController.getmoodById);
router.post('/entry', PostController.moodentry);
router.delete('/:id', PostController.deletePost);

module.exports = router;

