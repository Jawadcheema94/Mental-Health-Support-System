
// // import 'package:flutter/material.dart';

// // class AdminProvider extends ChangeNotifier {
// //   bool isLoading = true;
// //   int totalUsers = 0;
// //   List<String> feedback = [];
// //   List<Map<String, dynamic>> transactions = [];

// //   AdminProvider() {
// //     _loadDashboardData();
// //   }

// //   Future<void> _loadDashboardData() async {
// //     // Simulate API calls with dummy data
// //     await Future.delayed(const Duration(seconds: 2));
// //     totalUsers = 120; // Example data
// //     feedback = ["Great app!", "Needs more features", "Loving it so far!"];
// //     transactions = [
// //       {"id": "T001", "amount": 29.99},
// //       {"id": "T002", "amount": 49.99},
// //       {"id": "T003", "amount": 19.99},
// //     ];
// //     isLoading = false;
// //     notifyListeners();
// //   }
// // }

// import 'package:flutter/material.dart';

// class AdminScreen extends StatelessWidget {
//   const AdminScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MindEase Admin Panel'),
//         backgroundColor: Colors.indigo,
//       ),
//       body: FutureBuilder<List<AdminSection>>(
//         future: fetchAdminSections(), // Function to fetch data from API
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final sections = snapshot.data!;
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: sections
//                       .map((section) => Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SectionTitle(title: section.title),
//                               ...section.cards.map((card) => AdminCard(
//                                     icon: card.icon,
//                                     title: card.title,
//                                     subtitle: card.subtitle,
//                                     onTap: () => handleCardTap(context, card),
//                                   )),
//                               SizedBox(height: 20),
//                             ],
//                           ))
//                       .toList(),
//                 ),
//               ),
//             );
//           } else {
//             return Center(child: Text('No data available.'));
//           }
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Users',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         selectedItemColor: Colors.indigo,
//         unselectedItemColor: Colors.grey,
//         onTap: (index) {
//           // Handle navigation between sections
//         },
//       ),
//       floatingActionButton: StreamBuilder<String>(
//         stream: systemNotificationsStream(), // Stream of notifications
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return FloatingActionButton.extended(
//               onPressed: () {
//                 // Show detailed notifications screen
//               },
//               icon: Icon(Icons.notifications),
//               label: Text(snapshot.data!),
//               backgroundColor: Colors.indigo,
//             );
//           }
//           return SizedBox.shrink(); // Hide FAB when no notifications
//         },
//       ),
//     );
//   }

//   Future<List<AdminSection>> fetchAdminSections() async {
//     // Simulate API call with dummy data
//     await Future.delayed(Duration(seconds: 2)); // Simulate network latency
//     return [
//       AdminSection(
//         title: 'User Management',
//         cards: [
//           AdminCardModel(
//             icon: Icons.person,
//             title: 'View Users',
//             subtitle: 'Manage and search app users',
//             action: () => print('View Users tapped'),
//           ),
//           AdminCardModel(
//             icon: Icons.block,
//             title: 'Ban Users',
//             subtitle: 'Restrict access for specific users',
//             action: () => print('Ban Users tapped'),
//           ),
//         ],
//       ),
//       AdminSection(
//         title: 'Content Moderation',
//         cards: [
//           AdminCardModel(
//             icon: Icons.report,
//             title: 'Review Reports',
//             subtitle: 'Moderate flagged content',
//             action: () => print('Review Reports tapped'),
//           ),
//           AdminCardModel(
//             icon: Icons.edit,
//             title: 'Edit Content',
//             subtitle: 'Manage app posts and content',
//             action: () => print('Edit Content tapped'),
//           ),
//         ],
//       ),
//       AdminSection(
//         title: 'Analytics Dashboard',
//         cards: [
//           AdminCardModel(
//             icon: Icons.bar_chart,
//             title: 'View Analytics',
//             subtitle: 'Track app performance',
//             action: () => print('View Analytics tapped'),
//           ),
//         ],
//       ),
//     ];
//   }

//   Stream<String> systemNotificationsStream() async* {
//     // Simulate a stream of notifications
//     await Future.delayed(Duration(seconds: 5)); // Wait before first notification
//     yield 'New User Reports Available';
//     await Future.delayed(Duration(seconds: 10));
//     yield 'Server Maintenance Scheduled';
//   }

//   void handleCardTap(BuildContext context, AdminCardModel card) {
//     // Handle tap for AdminCard (navigate or perform actions)
//     if (card.action != null) card.action!();
//   }
// }

// // Models for sections and cards
// class AdminSection {
//   final String title;
//   final List<AdminCardModel> cards;

//   AdminSection({required this.title, required this.cards});
// }

// class AdminCardModel {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback? action;

//   AdminCardModel({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     this.action,
//   });
// }

// // Section title widget
// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.indigo,
//         ),
//       ),
//     );
//   }
// }

// // Admin card widget
// class AdminCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   const AdminCard({super.key, 
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         margin: EdgeInsets.symmetric(vertical: 8),
//         child: ListTile(
//           leading: Icon(icon, color: Colors.indigo),
//           title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//           subtitle: Text(subtitle),
//           trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo),
//         ),
//       ),
//     );
//   }
// }