import 'package:flutter/material.dart';

class DepressionScreen extends StatelessWidget {
  const DepressionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Depression',
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
                      '- Persistent sadness or low mood\n'
                      '- Loss of interest in activities\n'
                      '- Fatigue or low energy\n'
                      '- Feelings of worthlessness or guilt\n'
                      '- Difficulty concentrating\n'
                      '- Changes in appetite or weight\n'
                      '- Sleep disturbances (insomnia or oversleeping)\n'
                      '- Thoughts of self-harm or suicide',
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
                      '- Biological factors (e.g., chemical imbalances in the brain)\n'
                      '- Genetic predisposition (family history of depression)\n'
                      '- Traumatic life events (e.g., loss of a loved one)\n'
                      '- Chronic stress or abuse\n'
                      '- Medical conditions (e.g., thyroid disorders)\n'
                      '- Substance abuse',
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
                      '- Impaired relationships and social isolation\n'
                      '- Decreased work or academic performance\n'
                      '- Physical health issues (e.g., chronic pain, weakened immune system)\n'
                      '- Increased risk of substance abuse\n'
                      '- Higher likelihood of self-harm or suicide\n'
                      '- Financial difficulties due to reduced productivity',
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