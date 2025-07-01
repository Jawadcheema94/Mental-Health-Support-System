import 'package:flutter/material.dart';
import 'package:myapp/admin.dart';
import 'package:myapp/analysis.dart';
import 'package:myapp/appointment.dart';
import 'package:myapp/components/onboarding_screen.dart';
import 'package:myapp/forget-password.dart';
import 'package:myapp/journaling.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/mood_tracking.dart';
import 'package:myapp/settings.dart';
import 'package:myapp/signup_page.dart';
import 'package:myapp/therapist.dart';
import 'package:myapp/therapist_dashboard.dart';
// import 'package:myapp/login_page.dart';
// import 'package:myapp/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 165, 131, 223)),
        useMaterial3: true,
      ),
      // home: MyAppointmentsScreen(userId: '680aad8bdef6a277563a942c'), // Replace with your user ID and type
      initialRoute: '/', // Initial route to load
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(), // Default screen
        '/admin': (context) => AdminScreen(),
        '/therapist': (context) => TherapistScreen(),
        '/mood_tracking': (context) => MoodTrackingScreen(), // Replace 'defaultUserType' with the actual user type
        '/journaling': (context) => JournalScreen(userId: '',),
        '/analysis': (context) => AnxietyDepressionTestScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/settings': (context) => SettingsScreen(),
        // '/appointment': (context) => MyAppointmentsScreen(userId: '680aad8bdef6a277563a942c'), // Replace with your user ID and type
      },
    );
  }
}
