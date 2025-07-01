import 'package:flutter/material.dart';

class TherapistDetailScreen extends StatelessWidget {
  final Map<String, dynamic> therapist;
  final String userId;

  const TherapistDetailScreen({
    super.key,
    required this.therapist,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          therapist['name'] ?? 'Therapist',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: isSmallScreen ? 30 : 40,
                      child: Image.asset(
                        'assets/images/user.png',
                        width: isSmallScreen ? 50 : 60,
                        height: isSmallScreen ? 50 : 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            therapist['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 8),
                          Text(
                            therapist['specialty'] ?? 'Therapist',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            therapist['location'] ?? 'Unknown Location',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            therapist['email'] ?? 'No email provided',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Text(
              "Book an Appointment",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 5 : 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/physical_appointment',
                        arguments: {
                          'therapist': therapist,
                          'userId': userId,
                        },
                      );
                    },
                    child: Text(
                      "Physical Meeting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 5 : 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/online_appointment',
                        arguments: {
                          'therapist': therapist,
                          'userId': userId,
                        },
                      );
                    },
                    child: Text(
                      "Online Meeting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}