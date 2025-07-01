import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:myapp/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';





class TherapistDashboard extends StatefulWidget {
    final String therapistId;

  const TherapistDashboard({Key? key, required this.therapistId}) : super(key: key);
  

  @override
  State<TherapistDashboard> createState() => _TherapistDashboardState();
}

class _TherapistDashboardState extends State<TherapistDashboard> {
  int _selectedIndex = 0;
  DateTime _currentDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  // Dynamic data
  List<Patient> _patients = [];
  List<Appointment> _todayAppointments = [];
  bool _isLoadingPatients = true;
  bool _isLoadingAppointments = true;
  String? _patientsError;
  String? _appointmentsError;

  final List<Task> _tasks = [
    Task(id: 1, title: 'Complete patient notes', deadline: DateTime.now(), isCompleted: false),
    Task(id: 2, title: 'Prepare for group therapy session', deadline: DateTime.now().add(const Duration(days: 1)), isCompleted: false),
    Task(id: 3, title: 'Review treatment plans', deadline: DateTime.now().add(const Duration(days: 2)), isCompleted: false),
    Task(id: 4, title: 'Insurance paperwork', deadline: DateTime.now().add(const Duration(days: 3)), isCompleted: true),
  ];

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _fetchAppointments();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      _isLoadingPatients = true;
      _patientsError = null;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/appointments/therapist/${widget.therapistId}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _patients = data.map((item) => Patient.fromJson(item)).toList();
        });
      } else {
        setState(() {
          _patientsError = 'Failed to load patients: [38;5;1m${response.statusCode}[0m';
        });
      }
    } catch (e) {
      setState(() {
        _patientsError = 'Error fetching patients: $e';
      });
    } finally {
      setState(() {
        _isLoadingPatients = false;
      });
    }
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      _isLoadingAppointments = true;
      _appointmentsError = null;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/appointments/therapist/${widget.therapistId}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _todayAppointments = data.map((item) => Appointment.fromJson(item)).toList();
        });
      } else {
        setState(() {
          _appointmentsError = 'Failed to load appointments: [38;5;1m${response.statusCode}[0m';
        });
      }
    } catch (e) {
      setState(() {
        _appointmentsError = 'Error fetching appointments: $e';
      });
    } finally {
      setState(() {
        _isLoadingAppointments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapist Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Dr. Emily Johnson',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Clinical Psychologist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Patients'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointments'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Tasks'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new appointment or task
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildPatientsView();
      case 2:
        return _buildAppointmentsView();
      case 3:
        return _buildTasksView();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Dr. Johnson',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          
          // Overview Cards
          _isLoadingPatients || _isLoadingAppointments
              ? const Center(child: CircularProgressIndicator())
              : _buildOverviewCards(),
          
          const SizedBox(height: 24),
          
          // Today's Appointments
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Appointments",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (_isLoadingAppointments)
                    const Center(child: CircularProgressIndicator())
                  else if (_appointmentsError != null)
                    Text(_appointmentsError!, style: const TextStyle(color: Colors.red))
                  else if (_todayAppointments.isEmpty)
                    const Text('No appointments for today.')
                  else ..._todayAppointments.map((appointment) => _buildAppointmentItem(appointment)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Calendar Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendar',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  // SizedBox(
                  //   height: 300,
                  //   child: CalendarCarousel<Event>(
                  //     onDayPressed: (date, events) {
                  //       setState(() {
                  //         _currentDate = date;
                  //       });
                  //     },
                  //     weekendTextStyle: const TextStyle(color: Colors.red),
                  //     thisMonthDayBorderColor: Colors.grey,
                  //     daysHaveCircularBorder: true,
                  //     showOnlyCurrentMonthDate: false,
                  //     weekFormat: false,
                  //     height: 300.0,
                  //     selectedDateTime: _currentDate,
                  //     selectedDayButtonColor: Colors.teal,
                  //     todayButtonColor: Colors.teal.withOpacity(0.3),
                  //     todayBorderColor: Colors.teal,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tasks Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Tasks',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  ..._tasks.where((task) => !task.isCompleted).take(3).map((task) => _buildTaskItem(task)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Patient Progress Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patient Progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (_isLoadingPatients)
                    const Center(child: CircularProgressIndicator())
                  else if (_patientsError != null)
                    Text(_patientsError!, style: const TextStyle(color: Colors.red))
                  else if (_patients.isEmpty)
                    const Text('No patients found.')
                  else ..._patients.take(3).map((patient) => _buildPatientProgressItem(patient)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildOverviewCard(
          title: 'Patients',
          value: _isLoadingPatients ? '...' : '${_patients.length}',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _buildOverviewCard(
          title: 'Appointments',
          value: _isLoadingAppointments ? '...' : '${_todayAppointments.length}',
          icon: Icons.calendar_today,
          color: Colors.orange,
        ),
        _buildOverviewCard(
          title: 'Tasks',
          value: '${_tasks.where((task) => !task.isCompleted).length}',
          icon: Icons.assignment,
          color: Colors.green,
        ),
        _buildOverviewCard(
          title: 'Completed',
          value: '${_tasks.where((task) => task.isCompleted).length}',
          icon: Icons.check_circle,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(Appointment appointment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.access_time,
              color: Colors.teal,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment.time} | ${appointment.duration} mins | ${appointment.type}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              setState(() {
                task.isCompleted = value ?? false;
              });
            },
            activeColor: Colors.teal,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${_dateFormat.format(task.deadline)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPatientProgressItem(Patient patient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Text(
                  patient.name.substring(0, 1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Next Appointment: ${_dateFormat.format(patient.nextAppointment)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: patient.progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(patient.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsView() {
    if (_isLoadingPatients) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_patientsError != null) {
      return Center(child: Text(_patientsError!, style: const TextStyle(color: Colors.red)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _patients.length,
      itemBuilder: (context, index) {
        final patient = _patients[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                patient.name.substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              patient.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Age: ${patient.age}'),
                Text('Next appointment: ${_dateFormat.format(patient.nextAppointment)}'),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // View patient details
            },
          ),
        );
      },
    );
  }

  Widget _buildAppointmentsView() {
    if (_isLoadingAppointments) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_appointmentsError != null) {
      return Center(child: Text(_appointmentsError!, style: const TextStyle(color: Colors.red)));
    }
    return Column(
      children: [
        // Calendar at the top
        // SizedBox(
        //   height: 350,
        //   child: CalendarCarousel<Event>(
        //     onDayPressed: (date, events) {
        //       setState(() {
        //         _currentDate = date;
        //       });
        //     },
        //     weekendTextStyle: const TextStyle(color: Colors.red),
        //     thisMonthDayBorderColor: Colors.grey,
        //     daysHaveCircularBorder: true,
        //     showOnlyCurrentMonthDate: false,
        //     weekFormat: false,
        //     height: 350.0,
        //     selectedDateTime: _currentDate,
        //     selectedDayButtonColor: Colors.teal,
        //     todayButtonColor: Colors.teal.withOpacity(0.3),
        //     todayBorderColor: Colors.teal,
        //     headerTextStyle: const TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.teal,
        //     ),
        //   ),
        // ),
        
        // Appointments for selected date
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointments for ${DateFormat('MMMM d, yyyy').format(_currentDate)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todayAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = _todayAppointments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                appointment.time.substring(0, 2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            appointment.patientName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('${appointment.time} - ${appointment.duration} mins'),
                              Text(appointment.type),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          onTap: () {
                            // View appointment details
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Pending Tasks
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tasks.where((task) => !task.isCompleted).length,
                  itemBuilder: (context, index) {
                    final task = _tasks.where((task) => !task.isCompleted).toList()[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            setState(() {
                              task.isCompleted = value ?? false;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                        title: Text(
                          task.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Due: ${_dateFormat.format(task.deadline)}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                // Completed Tasks
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tasks.where((task) => task.isCompleted).length,
                  itemBuilder: (context, index) {
                    final task = _tasks.where((task) => task.isCompleted).toList()[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            setState(() {
                              task.isCompleted = value ?? false;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                        title: Text(
                          task.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Completed'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Models
class Patient {
  final int id;
  final String name;
  final int age;
  final DateTime nextAppointment;
  final double progress;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.nextAppointment,
    required this.progress,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? json['_id'] ?? 0,
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      nextAppointment: DateTime.parse(json['nextAppointment']),
      progress: (json['progress'] is int)
          ? (json['progress'] as int).toDouble()
          : (json['progress'] ?? 0.0),
    );
  }
}

class Appointment {
  final int id;
  final String patientName;
  final String time;
  final int duration;
  final String type;

  Appointment({
    required this.id,
    required this.patientName,
    required this.time,
    required this.duration,
    required this.type,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? json['_id'] ?? 0,
      patientName: json['patientName'] ?? '',
      time: json['time'] ?? '',
      duration: json['duration'] ?? 0,
      type: json['type'] ?? '',
    );
  }
}

class Task {
  final int id;
  final String title;
  final DateTime deadline;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.isCompleted,
  });
}

