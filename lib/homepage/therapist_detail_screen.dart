import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class TherapistDetailScreen extends StatefulWidget {
  final Map<String, dynamic> therapist;
  final String userId;

  const TherapistDetailScreen({
    super.key,
    required this.therapist,
    required this.userId,
  });

  @override
  State<TherapistDetailScreen> createState() => _TherapistDetailScreenState();
}

class _TherapistDetailScreenState extends State<TherapistDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          widget.therapist['name'] ?? 'Therapist',
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
                            widget.therapist['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 8),
                          Text(
                            widget.therapist['specialty'] ?? 'Therapist',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            widget.therapist['location'] ?? 'Unknown Location',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            widget.therapist['email'] ?? 'No email provided',
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
            SizedBox(height: isSmallScreen ? 15 : 25),

            // Book Appointment Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book an Appointment",
                    style: AppTheme.headingMedium.copyWith(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose your preferred meeting type:",
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusM),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 12 : 16,
                              horizontal: AppTheme.spacingM,
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/physical_appointment',
                              arguments: {
                                'therapist': widget.therapist,
                                'userId': widget.userId,
                              },
                            );
                          },
                          child: Text(
                            "Physical Meeting",
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 5 : 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusM),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 12 : 16,
                              horizontal: AppTheme.spacingM,
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/online_appointment',
                              arguments: {
                                'therapist': widget.therapist,
                                'userId': widget.userId,
                              },
                            );
                          },
                          child: Text(
                            "Online Meeting",
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Payment Section
                  Text(
                    "Payment Options",
                    style: AppTheme.headingMedium.copyWith(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.warningColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusM),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 12 : 16,
                              horizontal: AppTheme.spacingM,
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: {
                                'userId': widget.userId,
                                'amount': 75.0, // Consultation fee
                                'description':
                                    'Consultation with ${widget.therapist['name']}',
                                'therapistId': widget.therapist['_id'],
                              },
                            );
                          },
                          icon: const Icon(Icons.payment),
                          label: Text(
                            "Pay Consultation Fee (\$75)",
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: isSmallScreen ? 16 : 20),

            // Payment Section
            Text(
              "Payment Options",
              style: AppTheme.headingMedium.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warningColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 16,
                        horizontal: AppTheme.spacingM,
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/payment',
                        arguments: {
                          'userId': widget.userId,
                          'amount': 75.0, // Consultation fee
                          'description':
                              'Consultation with ${widget.therapist['name']}',
                          'therapistId': widget.therapist['_id'],
                        },
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: Text(
                      "Pay Consultation Fee (\$75)",
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w600,
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
