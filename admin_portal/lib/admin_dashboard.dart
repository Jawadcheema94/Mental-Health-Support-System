import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AdminDashboard extends StatefulWidget {
  final String adminId;
  final String adminName;

  const AdminDashboard({
    super.key,
    required this.adminId,
    required this.adminName,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  final List<String> _titles = [
    'Dashboard Overview',
    'User Management',
    'Therapist Management',
    'Appointment Management',
    'Payment Management',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDashboardStats();
  }

  Future<void> _fetchDashboardStats() async {
    try {
      final usersResponse = await http.get(Uri.parse('http://localhost:3000/api/users'));
      final therapistsResponse = await http.get(Uri.parse('http://localhost:3000/api/therapists'));
      final appointmentsResponse = await http.get(Uri.parse('http://localhost:3000/api/appointments'));

      if (usersResponse.statusCode == 200 && 
          therapistsResponse.statusCode == 200 && 
          appointmentsResponse.statusCode == 200) {
        
        final users = json.decode(usersResponse.body) as List;
        final therapists = json.decode(therapistsResponse.body) as List;
        final appointments = json.decode(appointmentsResponse.body) as List;

        setState(() {
          _stats = {
            'totalUsers': users.length,
            'totalTherapists': therapists.length,
            'totalAppointments': appointments.length,
            'todayAppointments': appointments.where((apt) {
              final aptDate = DateTime.parse(apt['date'] ?? '');
              final today = DateTime.now();
              return aptDate.year == today.year && 
                     aptDate.month == today.month && 
                     aptDate.day == today.day;
            }).length,
            'revenue': appointments.fold(0.0, (sum, apt) => sum + (apt['fee'] ?? 0.0)),
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDashboardStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _selectedIndex == 0 ? _buildOverview() : _buildComingSoon(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome, ${widget.adminName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'MindEase Admin Portal',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.dashboard, 'Dashboard Overview', 0),
                _buildDrawerItem(Icons.people, 'User Management', 1),
                _buildDrawerItem(Icons.psychology, 'Therapist Management', 2),
                _buildDrawerItem(Icons.calendar_today, 'Appointment Management', 3),
                _buildDrawerItem(Icons.payment, 'Payment Management', 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? const Color(0xFF0891B2) : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? const Color(0xFF0891B2) : Colors.black87,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildOverview() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  'Total Users',
                  '${_stats['totalUsers'] ?? 0}',
                  Icons.people,
                  const Color(0xFF10B981),
                ),
                _buildStatCard(
                  'Total Therapists',
                  '${_stats['totalTherapists'] ?? 0}',
                  Icons.psychology,
                  const Color(0xFF3B82F6),
                ),
                _buildStatCard(
                  'Total Appointments',
                  '${_stats['totalAppointments'] ?? 0}',
                  Icons.calendar_today,
                  const Color(0xFF8B5CF6),
                ),
                _buildStatCard(
                  'Today\'s Appointments',
                  '${_stats['todayAppointments'] ?? 0}',
                  Icons.today,
                  const Color(0xFFF59E0B),
                ),
                _buildStatCard(
                  'Total Revenue',
                  '\$${(_stats['revenue'] ?? 0.0).toStringAsFixed(2)}',
                  Icons.attach_money,
                  const Color(0xFFEF4444),
                ),
                _buildStatCard(
                  'System Status',
                  'Online',
                  Icons.check_circle,
                  const Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoon() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This feature is under development',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
