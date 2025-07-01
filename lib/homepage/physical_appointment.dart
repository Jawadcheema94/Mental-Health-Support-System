import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PhysicalAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> therapist;
  final String userId;

  const PhysicalAppointmentScreen({
    super.key,
    required this.therapist,
    required this.userId,
  });

  @override
  _PhysicalAppointmentScreenState createState() =>
      _PhysicalAppointmentScreenState();
}

class _PhysicalAppointmentScreenState extends State<PhysicalAppointmentScreen> {
  DateTime? selectedDateTime;
  int? selectedDuration = 60;
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _bookAppointment() async {
    if (selectedDateTime == null) {
      setState(() {
        errorMessage = 'Please select a date and time';
      });
      return;
    }
    if (selectedDateTime!.isBefore(DateTime.now())) {
      setState(() {
        errorMessage = 'Cannot book appointments in the past';
      });
      return;
    }
    if (widget.userId.isEmpty) {
      setState(() {
        errorMessage = 'User ID is missing';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'therapistId': widget.therapist['_id'],
          'appointmentDate': selectedDateTime!.toUtc().toIso8601String(),
          'duration': selectedDuration,
          'notes': notesController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Physical appointment booked with ${widget.therapist['name']}',
              ),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          errorMessage = errorData['message'] ?? 'Failed to book appointment';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Book Physical Appointment - ${widget.therapist['name']}',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 16 : 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date and Time',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _selectDateTime(context),
                      child: Text(
                        selectedDateTime == null
                            ? 'Pick Date & Time'
                            : DateFormat('yyyy-MM-dd HH:mm')
                                .format(selectedDateTime!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Text(
                      'Duration (minutes)',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    DropdownButton<int>(
                      value: selectedDuration,
                      items: const [
                        DropdownMenuItem(value: 30, child: Text('30 minutes')),
                        DropdownMenuItem(value: 60, child: Text('60 minutes')),
                        DropdownMenuItem(value: 90, child: Text('90 minutes')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value;
                        });
                      },
                      isExpanded: true,
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Any specific concerns or notes...',
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: isLoading ? null : _bookAppointment,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Book Appointment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
