import 'package:flutter/material.dart';
import 'package:myapp/admin/admin_login.dart';
import 'package:myapp/analysis.dart';
import 'package:myapp/ai_analysis_screen.dart';
import 'package:myapp/payment_screen.dart';
import 'package:myapp/appointment.dart';
import 'package:myapp/components/onboarding_screen.dart';
import 'package:myapp/journaling.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/mood_journal.dart';
import 'package:myapp/settings.dart';
import 'package:myapp/signup_page.dart';
import 'package:myapp/therapist.dart';
import 'package:myapp/video_call_screen.dart';
import 'package:myapp/homepage/physical_appointment.dart';
import 'package:myapp/homepage/online_appointment.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/services/stripe_service.dart';
import 'package:myapp/services/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe with error handling to prevent app crashes
  try {
    await StripeService.init();
    debugPrint('Stripe initialized successfully');
  } catch (e) {
    debugPrint('Stripe initialization failed: $e');
    // App continues to work even if Stripe fails to initialize
  }

  // Initialize localization service
  await LocalizationService().loadSavedLanguage();

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
        '/admin': (context) => const AdminLoginScreen(),
        '/therapist': (context) => TherapistScreen(),
        // '/mood_tracking': (context) =>
        //     MoodTrackingScreen(), // Replace 'defaultUserType' with the actual user type
        '/journaling': (context) => JournalScreen(
              userId: '',
            ),
        '/mood_journal': (context) => MoodJournalScreen(),
        '/analysis': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return AIAnalysisScreen(
            userId: args?['userId'] ?? '',
          );
        },
        '/anxiety_depression_test': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return AnxietyDepressionTestScreen(
            userId: args?['userId'] ?? '',
          );
        },
        '/payment': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return PaymentScreen(
            userId: args?['userId'] ?? '',
            amount: args?['amount'] ?? 0.0,
            description: args?['description'] ?? 'Mental Health Service',
            therapistId: args?['therapistId'],
            appointmentId: args?['appointmentId'],
          );
        },
        '/onboarding': (context) => OnboardingScreen(),
        '/settings': (context) => const SettingsScreen(userId: ''),
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
        '/appointment': (context) => const MyAppointmentsScreen(
            userId: ''), // Will be handled dynamically
      },
    );
  }
}
