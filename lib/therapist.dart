import 'package:flutter/material.dart';

class TherapistScreen extends StatelessWidget {
  const TherapistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Therapist Dashboard'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the main page
            Navigator.pop(context); // Use Navigator.pushNamed(context, '/home') if needed
          },
        ),
      ),
      body: FutureBuilder<TherapistDashboardData>(
        future: fetchTherapistDashboardData(), // Fetch data from API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Today's Schedule
                    SectionTitle(title: 'Today\'s Schedule'),
                    ...data.schedule.map((schedule) => ScheduleCard(
                          time: schedule.time,
                          clientName: schedule.clientName,
                          sessionType: schedule.sessionType,
                          onTap: () => handleScheduleTap(context, schedule),
                        )),
                    SizedBox(height: 20),

                    // Section: Client List
                    SectionTitle(title: 'Clients'),
                    ...data.clients.map((client) => ClientCard(
                          clientName: client.name,
                          lastSession: client.lastSession,
                          onTap: () => handleClientTap(context, client),
                        )),
                    SizedBox(height: 20),

                    // Section: Analytics & Tools
                    SectionTitle(title: 'Analytics & Tools'),
                    ...data.tools.map((tool) => ToolCard(
                          icon: tool.icon,
                          title: tool.title,
                          description: tool.description,
                          onTap: () => handleToolTap(context, tool),
                        )),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation
        },
      ),
      floatingActionButton: StreamBuilder<String>(
        stream: realTimeMessagesStream(), // Stream for live updates
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              onPressed: () {
                // Navigate to notifications/messages screen
              },
              icon: Icon(Icons.message),
              label: Text(snapshot.data!),
              backgroundColor: Colors.teal,
            );
          }
          return SizedBox.shrink(); // Hide FAB if no updates
        },
      ),
    );
  }

  Future<TherapistDashboardData> fetchTherapistDashboardData() async {
    // Simulate API call with mock data
    await Future.delayed(Duration(seconds: 2));
    return TherapistDashboardData(
      schedule: [
        Schedule(time: '10:00 AM', clientName: 'John Doe', sessionType: 'Therapy Session'),
        Schedule(time: '1:30 PM', clientName: 'Jane Smith', sessionType: 'Follow-up Session'),
      ],
      clients: [
        Client(name: 'John Doe', lastSession: 'Last session: Dec 5, 2024'),
        Client(name: 'Jane Smith', lastSession: 'Last session: Dec 1, 2024'),
      ],
      tools: [
        Tool(icon: Icons.bar_chart, title: 'Client Progress', description: 'View insights and session stats'),
        Tool(icon: Icons.notes, title: 'Session Notes', description: 'Quickly jot down notes'),
        Tool(icon: Icons.psychology, title: 'Guided Exercises', description: 'Access mindfulness tools'),
      ],
    );
  }

  Stream<String> realTimeMessagesStream() async* {
    // Simulate real-time messages
    await Future.delayed(Duration(seconds: 5));
    yield 'New Message from Jane Smith';
    await Future.delayed(Duration(seconds: 10));
    yield 'Upcoming session reminder: 10:00 AM';
  }

  void handleScheduleTap(BuildContext context, Schedule schedule) {
    // Navigate to session details
    print('Tapped on schedule: ${schedule.clientName}');
  }

  void handleClientTap(BuildContext context, Client client) {
    // Navigate to client profile
    print('Tapped on client: ${client.name}');
  }

  void handleToolTap(BuildContext context, Tool tool) {
    // Navigate to tool screen
    print('Tapped on tool: ${tool.title}');
  }
}

// Data Models
class TherapistDashboardData {
  final List<Schedule> schedule;
  final List<Client> clients;
  final List<Tool> tools;

  TherapistDashboardData({required this.schedule, required this.clients, required this.tools});
}

class Schedule {
  final String time;
  final String clientName;
  final String sessionType;

  Schedule({required this.time, required this.clientName, required this.sessionType});
}

class Client {
  final String name;
  final String lastSession;

  Client({required this.name, required this.lastSession});
}

class Tool {
  final IconData icon;
  final String title;
  final String description;

  Tool({required this.icon, required this.title, required this.description});
}

// Reusable Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
}

// Reusable Schedule Card Widget
class ScheduleCard extends StatelessWidget {
  final String time;
  final String clientName;
  final String sessionType;
  final VoidCallback onTap;

  const ScheduleCard({super.key, 
    required this.time,
    required this.clientName,
    required this.sessionType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(Icons.access_time, color: Colors.teal),
          title: Text('$time - $clientName'),
          subtitle: Text(sessionType),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
        ),
      ),
    );
  }
}

// Reusable Client Card Widget
class ClientCard extends StatelessWidget {
  final String clientName;
  final String lastSession;
  final VoidCallback onTap;

  const ClientCard({super.key, 
    required this.clientName,
    required this.lastSession,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(Icons.person, color: Colors.teal),
          title: Text(clientName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(lastSession),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
        ),
      ),
    );
  }
}

// Reusable Tool Card Widget
class ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ToolCard({super.key, 
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
        ),
      ),
    );
  }
}