const express = require('express');
const router = express.Router();

router.get('/oauth/callback', async (req, res) => {
  const code = req.query.code;

  if (!code) {
    return res.status(400).send('Authorization code missing');
  }

  try {
    const tokenData = await getAccessTokenFromCode(code);
    // Save tokenData.access_token and tokenData.refresh_token securely for this user

    res.json({ message: 'Authorization successful', tokenData });
  } catch (error) {
    console.error('OAuth token error:', error.response?.data || error.message);
    res.status(500).send('Failed to get access token');
  }
});

// Example endpoint to create meeting using saved token (token management required)
router.post('/create', async (req, res) => {
  // In a real app, you must get the user’s saved access_token from DB or session
  const accessToken = req.body.accessToken; // for testing, pass in request body

  if (!accessToken) {
    return res.status(400).json({ error: 'Access token required' });
  }

  try {
    const meeting = await createMeeting(accessToken);
    res.json({ meetingUrl: meeting.join_url, meetingId: meeting.id });
  } catch (error) {
    console.error('Create meeting error:', error.response?.data || error.message);
    res.status(500).json({ error: 'Failed to create meeting' });
  }
});

module.exports = router;
