import 'package:flutter/material.dart';

class AllTherapistsScreen extends StatelessWidget {
  final List<dynamic> therapists;
  final String userId;

  const AllTherapistsScreen({
    super.key,
    required this.therapists,
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
          "All Therapists",
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: therapists.isEmpty
          ? const Center(
              child: Text(
                "No therapists available",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
              itemCount: therapists.length,
              itemBuilder: (context, index) {
                final therapist = therapists[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/therapist_detail',
                      arguments: {
                        'therapist': therapist,
                        'userId': userId,
                      },
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: isSmallScreen ? 25 : 30,
                            child: Image.asset(
                              'assets/images/user.png',
                              width: isSmallScreen ? 40 : 50,
                              height: isSmallScreen ? 40 : 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  therapist['name'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                                Text(
                                  therapist['specialty'] ?? 'Therapist',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 10 : 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  therapist['location'] ?? 'Unknown Location',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 10 : 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.purple),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}