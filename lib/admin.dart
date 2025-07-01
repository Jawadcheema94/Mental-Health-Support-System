// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class AdminScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('MINDEASE Admin Panel'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple,
//               ),
//               child: const Text(
//                 'Admin Menu',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.dashboard),
//               title: Text('Dashboard'),
//               onTap: () {}, // Navigate to Dashboard
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Users'),
//               onTap: () {}, // Navigate to User Management
//             ),
//             ListTile(
//               leading: Icon(Icons.notifications),
//               title: Text('Notifications'),
//               onTap: () {}, // Navigate to Notifications
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {}, // Navigate to Settings
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Dashboard',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildStatCard('Users', '120', Icons.people),
//                 _buildStatCard('Tasks', '80', Icons.task_alt),
//                 _buildStatCard('Revenue', '\$5k', Icons.monetization_on),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Analytics',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             AspectRatio(
//               aspectRatio: 1.7,
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: false),
//                   titlesData: FlTitlesData(show: true),
//                   borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(color: Colors.grey, width: 1),
//                   ),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: [
//                         FlSpot(0, 3),
//                         FlSpot(1, 1),
//                         FlSpot(2, 4),
//                         FlSpot(3, 2),
//                         FlSpot(4, 5),
//                       ],
//                       isCurved: true,
//                       barWidth: 4,
//                       color: Colors.deepPurple,
//                       belowBarData: BarAreaData(show: false),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, IconData icon) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Container(
//         width: 100,
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(icon, size: 32, color: Colors.deepPurple),
//             const SizedBox(height: 10),
//             Text(title, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MindEase Admin Panel'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: User Management
              SectionTitle(title: 'User Management'),
              AdminCard(
                icon: Icons.person,
                title: 'View Users',
                subtitle: 'Manage and search app users',
                onTap: () {
                  // Navigate to User Management Screen
                },
              ),
              AdminCard(
                icon: Icons.block,
                title: 'Ban Users',
                subtitle: 'Restrict access for specific users',
                onTap: () {
                  // Navigate to Ban Users Screen
                },
              ),
              SizedBox(height: 20),

              // Section: Content Moderation
              SectionTitle(title: 'Content Moderation'),
              AdminCard(
                icon: Icons.report,
                title: 'Review Reports',
                subtitle: 'Moderate flagged content',
                onTap: () {
                  // Navigate to Reports Screen
                },
              ),
              AdminCard(
                icon: Icons.edit,
                title: 'Edit Content',
                subtitle: 'Manage app posts and content',
                onTap: () {
                  // Navigate to Edit Content Screen
                },
              ),
              SizedBox(height: 20),

              // Section: Analytics
              SectionTitle(title: 'Analytics Dashboard'),
              AdminCard(
                icon: Icons.bar_chart,
                title: 'View Analytics',
                subtitle: 'Track app performance',
                onTap: () {
                  // Navigate to Analytics Screen
                },
              ),
              SizedBox(height: 20),

              // Section: Settings
              SectionTitle(title: 'Settings'),
              AdminCard(
                icon: Icons.settings,
                title: 'General Settings',
                subtitle: 'Manage app configurations',
                onTap: () {
                  // Navigate to Settings Screen
                },
              ),
              AdminCard(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Adjust notification preferences',
                onTap: () {
                  // Navigate to Notifications Screen
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation between sections
        },
      ),
    );
  }
}

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
          color: Colors.indigo,
        ),
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AdminCard({super.key, 
    required this.icon,
    required this.title,
    required this.subtitle,
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
          leading: Icon(icon, color: Colors.indigo),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo),
        ),
      ),
    );
  }
}