// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'admin_provider.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final adminProvider = Provider.of<AdminProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Dashboard'),
//         centerTitle: true,
//       ),
//       body: adminProvider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 children: [
//                   _buildMetricCard(
//                     title: "Total Users",
//                     value: adminProvider.totalUsers.toString(),
//                     icon: Icons.people,
//                   ),
//                   _buildMetricCard(
//                     title: "Feedback Count",
//                     value: adminProvider.feedback.length.toString(),
//                     icon: Icons.feedback,
//                   ),
//                   _buildMetricCard(
//                     title: "Transactions",
//                     value: adminProvider.transactions.length.toString(),
//                     icon: Icons.payment,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'User Feedback:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ...adminProvider.feedback.map((feedback) {
//                     return Card(
//                       child: ListTile(
//                         leading: const Icon(Icons.message),
//                         title: Text(feedback),
//                       ),
//                     );
//                   }),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Transaction History:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ...adminProvider.transactions.map((transaction) {
//                     return Card(
//                       child: ListTile(
//                         leading: const Icon(Icons.receipt),
//                         title: Text('Transaction ID: ${transaction['id']}'),
//                         subtitle: Text('Amount: \$${transaction['amount']}'),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildMetricCard({required String title, required String value, required IconData icon}) {
//     return Card(
//       child: ListTile(
//         leading: Icon(icon, size: 40, color: Colors.blue),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         trailing: Text(value, style: const TextStyle(fontSize: 18)),
//       ),
//     );
//   }
// }

// class AdminProvider {
// }
