const { google } = require('googleapis');

/**
 * Create a Google Meet event using Google Calendar API.
 * Expects `accessToken` and `eventDetails` in the request body.
 */
exports.createGoogleMeetEvent = async (req, res) => {
  const { accessToken, eventDetails } = req.body;

  if (!accessToken) {
    return res.status(400).json({ error: 'Access token required' });
  }

  if (!eventDetails) {
    return res.status(400).json({ error: 'Event details required' });
  }

  try {
    // Initialize OAuth2 client with dummy credentials (not needed here because we set token manually)
    const oAuth2Client = new google.auth.OAuth2();

    // Set user access token (required to authenticate API calls)
    oAuth2Client.setCredentials({ access_token: accessToken });

    // Initialize Google Calendar API client
    const calendar = google.calendar({ version: 'v3', auth: oAuth2Client });

    // Prepare event object with Google Meet conference data
    const event = {
      summary: eventDetails.summary || 'Consultation Meeting',
      description: eventDetails.description || 'Google Meet video consultation',
      start: {
        dateTime: eventDetails.startDateTime,
        timeZone: eventDetails.timeZone || 'UTC',
      },
      end: {
        dateTime: eventDetails.endDateTime,
        timeZone: eventDetails.timeZone || 'UTC',
      },
      attendees: eventDetails.attendees || [],
      conferenceData: {
        createRequest: {
          requestId: `req-${Date.now()}`,
          conferenceSolutionKey: { type: 'hangoutsMeet' },
        },
      },
    };

    // Insert the event into the user's primary calendar
    const response = await calendar.events.insert({
      calendarId: 'primary',
      resource: event,
      conferenceDataVersion: 1,
    });

    // Send back event and Meet links
    res.status(200).json({
      eventLink: response.data.htmlLink,
      meetLink: response.data.conferenceData.entryPoints[0].uri,
    });

  } catch (error) {
    console.error('Error creating Google Meet event:', error.response?.data || error.message);
    res.status(500).json({ error: 'Failed to create Google Meet event' });
  }
};
