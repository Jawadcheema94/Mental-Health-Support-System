const { google } = require('googleapis');
const fs = require('fs');
const path = require('path');

async function testGoogleMeetGeneration() {
  console.log('Testing Google Meet link generation...');
  
  try {
    // Load tokens from the config directory
    const TOKEN_PATH = path.join(__dirname, 'src/config/token.json');
    console.log('Looking for token file at:', TOKEN_PATH);
    
    if (!fs.existsSync(TOKEN_PATH)) {
      console.log('Google tokens not found at', TOKEN_PATH);
      return;
    }
    
    console.log('Token file found, reading tokens...');
    const tokens = JSON.parse(fs.readFileSync(TOKEN_PATH));
    console.log('Tokens loaded successfully');
    
    // Load Google credentials from the same file as server.js
    const CREDENTIALS = require('./src/config/client_secret_431597357563-si2t5nqkfuac5d4qfvterp8pf8tjihds.apps.googleusercontent.com.json');

    // Create OAuth2 client
    const oAuth2Client = new google.auth.OAuth2(
      CREDENTIALS.web.client_id,
      CREDENTIALS.web.client_secret,
      'http://localhost:3000/api/google-meet/oauth2callback'
    );
    
    oAuth2Client.setCredentials(tokens);
    console.log('OAuth2 client configured');
    
    const calendar = google.calendar({ version: 'v3', auth: oAuth2Client });
    console.log('Calendar API client created');
    
    const event = {
      summary: 'Test Therapy Session',
      description: 'Test therapy session via MindEase',
      start: {
        dateTime: new Date().toISOString(),
        timeZone: 'UTC',
      },
      end: {
        dateTime: new Date(Date.now() + 60 * 60 * 1000).toISOString(), // 1 hour
        timeZone: 'UTC',
      },
      conferenceData: {
        createRequest: {
          requestId: `therapy-test-${Date.now()}`,
          conferenceSolutionKey: { type: 'hangoutsMeet' },
        },
      },
    };

    console.log('Creating calendar event...');
    const response = await calendar.events.insert({
      calendarId: 'primary',
      resource: event,
      conferenceDataVersion: 1,
    });

    console.log('Calendar event created, extracting meet link...');
    const meetLink = response.data.conferenceData.entryPoints.find(
      (entry) => entry.entryPointType === 'video'
    ).uri;

    console.log('Generated Google Meet link:', meetLink);
    return meetLink;
    
  } catch (error) {
    console.error('Error generating meeting link:', error.message);
    console.error('Full error:', error);
  }
}

testGoogleMeetGeneration();
