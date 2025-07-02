const User = require('../models/User');

exports.updateLocation = async (req, res) => {
  const { userId, latitude, longitude } = req.body;

  // Validate required fields presence
  if (!userId) {
    return res.status(400).json({ error: 'User ID is required' });
  }

  // Validate latitude and longitude types and ranges
  if (
    typeof latitude !== 'number' ||
    typeof longitude !== 'number' ||
    latitude < -90 || latitude > 90 ||
    longitude < -180 || longitude > 180
  ) {
    return res.status(400).json({ error: 'Invalid latitude or longitude' });
  }

  try {
    // Find user by ID and update location
    const user = await User.findByIdAndUpdate(
      userId,
      {
        location: {
          type: 'Point',
          coordinates: [longitude, latitude],
        },
      },
      { new: true } // Return updated user document
    );

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Return success with updated location
    return res.status(200).json({
      message: 'Location updated successfully',
      location: user.location,
    });
  } catch (error) {
    console.error('Error updating location:', error);
    return res.status(500).json({ error: 'Failed to update location' });
  }
};
