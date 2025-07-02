import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myapp/admin.dart';
import 'package:myapp/admin/admin_login.dart';
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
import 'package:myapp/video_call_screen.dart';
import 'package:myapp/homepage/physical_appointment.dart';
import 'package:myapp/homepage/online_appointment.dart';
import 'package:myapp/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // COMMENTED OUT: Initialize Stripe with your publishable key
  // Stripe.publishableKey =
  //     'pk_test_51RCF7D2XdGiu93ZvZQcJgRtZDWfK1mxn2HyNUAMvaOBnbBfwu8opr4OIjcI1yssA92P88ZhXNsCkAODg2YemU3aR008klErbkH';
  // await Stripe.instance.applySettings();

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
      theme: AppTheme.lightTheme,
      // home: MyAppointmentsScreen(userId: '680aad8bdef6a277563a942c'), // Replace with your user ID and type
      initialRoute: '/', // Initial route to load
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(), // Default screen
        '/admin': (context) => AdminLoginScreen(),
        '/therapist': (context) => TherapistScreen(),
        '/mood_tracking': (context) =>
            MoodTrackingScreen(), // Replace 'defaultUserType' with the actual user type
        '/journaling': (context) => JournalScreen(
              userId: '',
            ),
        '/analysis': (context) => AnxietyDepressionTestScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/settings': (context) => SettingsScreen(),
        '/video_call': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return VideoCallScreen(
            meetingLink: args['meetingLink'],
            therapistName: args['therapistName'],
            userId: args['userId'],
          );
        },
        '/physical_appointment': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return PhysicalAppointmentScreen(
            therapist: args['therapist'],
            userId: args['userId'],
          );
        },
        '/online_appointment': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return OnlineAppointmentScreen(
            therapist: args['therapist'],
            userId: args['userId'],
          );
        },
        // '/appointment': (context) => MyAppointmentsScreen(userId: '680aad8bdef6a277563a942c'), // Replace with your user ID and type
      },
    );
  }
}
