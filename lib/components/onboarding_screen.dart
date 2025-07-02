import 'package:flutter/material.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      title: 'Welcome to MindEase',
      description:
          'Your journey to mental wellness starts here. Find peace, balance, and clarity in your daily life.',
      icon: Icons.psychology,
      gradient: AppTheme.healingGradient,
    ),
    OnboardingData(
      title: 'Connect with Therapists',
      description:
          'Book sessions with certified mental health professionals. Online or in-person appointments available.',
      icon: Icons.people_alt,
      gradient: AppTheme.primaryGradient,
    ),
    OnboardingData(
      title: 'Track Your Progress',
      description:
          'Monitor your mood, journal your thoughts, and see your mental health journey unfold.',
      icon: Icons.trending_up,
      gradient: AppTheme.calmGradient,
    ),
    OnboardingData(
      title: 'Find Your Peace',
      description:
          'Start your wellness journey today. Every step forward is a step towards a healthier mind.',
      icon: Icons.spa,
      gradient: AppTheme.backgroundGradient,
    ),
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      navigateToLogin();
    }
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Admin Portal Access Button
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin');
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Admin Portal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: onboardingData[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: currentIndex == index
                                ? AppTheme.primaryColor
                                : AppTheme.primaryColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Next/Get Started button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingM),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusM),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          currentIndex == onboardingData.length - 1
                              ? 'Begin Your Journey'
                              : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    // Skip button
                    TextButton(
                      onPressed: navigateToLogin,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: data.gradient,
              shape: BoxShape.circle,
              boxShadow: AppTheme.softShadow,
            ),
            child: Icon(
              data.icon,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Text(
            data.title,
            style: AppTheme.headingLarge.copyWith(
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            data.description,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
