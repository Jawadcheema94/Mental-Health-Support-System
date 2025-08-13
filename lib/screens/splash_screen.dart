import 'package:flutter/material.dart';
import 'package:myapp/services/session_service.dart';
import 'package:myapp/new_home_page.dart';
import 'package:myapp/therapist_dashboard.dart';
import 'package:myapp/components/onboarding_screen.dart';
import 'package:myapp/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();

    // Check for cached session after animation starts
    _checkSession();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));

    try {
      // Check if user has a valid cached session
      final hasValidSession = await SessionService.hasValidSession();

      if (hasValidSession) {
        // Get session data
        final sessionData = await SessionService.getSessionData();

        if (sessionData != null) {
          final userId = sessionData['userId']!;
          final userRole = sessionData['userRole']!;

          // Validate session with backend
          final isValidWithBackend =
              await SessionService.validateSessionWithBackend();

          if (isValidWithBackend) {
            // Navigate to appropriate screen based on user role
            if (mounted) {
              if (userRole == 'user') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewHomeScreen(userId: userId),
                  ),
                );
              } else if (userRole == 'therapist') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TherapistDashboard(therapistId: userId),
                  ),
                );
              } else {
                // Unknown role, go to onboarding
                _navigateToOnboarding();
              }
            }
            return;
          } else {
            // Session invalid with backend, clear it
            await SessionService.clearSession();
          }
        }
      }

      // No valid session, go to onboarding
      _navigateToOnboarding();
    } catch (error) {
      print('Session check error: $error');
      // On error, clear session and go to onboarding
      await SessionService.clearSession();
      _navigateToOnboarding();
    }
  }

  void _navigateToOnboarding() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6B73FF), // Primary blue from logo
              Color(0xFF9B59B6), // Purple accent
              Color(0xFF667eea), // Light blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo - Enhanced Visibility
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, -10),
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: const Color(0xFF6B73FF).withOpacity(0.3),
                              blurRadius: 50,
                              offset: const Offset(0, 25),
                              spreadRadius: 8,
                            ),
                            // Additional glow effect for prominence
                            BoxShadow(
                              color: const Color(0xFF9B59B6).withOpacity(0.2),
                              blurRadius: 60,
                              offset: const Offset(0, 0),
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo1.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App Name
                      const Text(
                        'MindEase',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tagline
                      Text(
                        'Your Mental Wellness Companion',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Loading indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Checking your session...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
