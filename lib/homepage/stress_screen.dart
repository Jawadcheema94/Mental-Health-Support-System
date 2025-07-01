import 'package:flutter/material.dart';

class StressScreen extends StatelessWidget {
  const StressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Stress',
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
                      '- Irritability or mood swings\n'
                      '- Headaches or muscle tension\n'
                      '- Fatigue or low energy\n'
                      '- Difficulty sleeping\n'
                      '- Racing thoughts or feeling overwhelmed\n'
                      '- Digestive issues (e.g., stomach aches)\n'
                      '- Changes in appetite\n'
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
                borderRadius: BorderRadius.circular(10),
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
                      '- Work or academic pressure\n'
                      '- Financial difficulties\n'
                      '- Relationship conflicts\n'
                      '- Major life changes (e.g., moving, job loss)\n'
                      '- Health problems\n'
                      '- Lack of work-life balance',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
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
                      'Effects',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Weakened immune system\n'
                      '- Increased risk of anxiety or depression\n'
                      '- Burnout or chronic fatigue\n'
                      '- Strained personal relationships\n'
                      '- Poor decision-making\n'
                      '- Physical health issues (e.g., high blood pressure)',
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