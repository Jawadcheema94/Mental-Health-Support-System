import 'package:flutter/material.dart';

class InsomniaScreen extends StatelessWidget {
  const InsomniaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Insomnia',
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
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Difficulty falling asleep\n'
                      '- Waking up frequently during the night\n'
                      '- Waking up too early\n'
                      '- Feeling unrefreshed after sleep\n'
                      '- Daytime fatigue or sleepiness\n'
                      '- Irritability or mood changes\n'
                      '- Trouble concentrating',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Causes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Stress or anxiety\n'
                      '- Poor sleep habits (e.g., irregular sleep schedule)\n'
                      '- Medical conditions (e.g., chronic pain, asthma)\n'
                      '- Medications or substance use (e.g., caffeine, alcohol)\n'
                      '- Mental health disorders (e.g., depression)\n'
                      '- Environmental factors (e.g., noise, light)',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effects',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Decreased cognitive function (e.g., memory issues)\n'
                      '- Increased risk of accidents or injuries\n'
                      '- Mood disturbances (e.g., irritability, anxiety)\n'
                      '- Weakened immune system\n'
                      '- Higher risk of chronic diseases (e.g., diabetes)\n'
                      '- Reduced quality of life',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
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
}