const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));

async function testAppointmentBooking() {
  try {
    const response = await fetch('http://localhost:3000/api/appointments', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: '6863fbe93605128f3bbb25d1',
        therapistId: '6863e421c9989b2d4ac5435e',
        appointmentDate: '2025-07-06T14:00:00.000Z',
        duration: 60,
        notes: 'Test appointment for real Google Meet link',
        type: 'online'
      })
    });

    const data = await response.json();

    if (response.ok) {
      console.log('Appointment created successfully!');
      console.log('Meeting Link:', data.meetingLink);
      console.log('Full response:', JSON.stringify(data, null, 2));
    } else {
      console.error('Error creating appointment:', data);
    }
  } catch (error) {
    console.error('Error creating appointment:', error.message);
  }
}

testAppointmentBooking();
