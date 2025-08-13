import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/login_page.dart';
import 'dart:async';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      title: '🌟 Welcome to MindEase',
      description:
          'Your journey to mental wellness starts here. Find peace, balance, and clarity in your daily life with our comprehensive mental health platform.',
      icon: Icons.psychology,
      gradient: const LinearGradient(
        colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFF4A90E2),
    ),
    OnboardingData(
      title: '🤝 Connect with Therapists',
      description:
          'Book sessions with certified mental health professionals. Online or in-person appointments available 24/7.',
      icon: Icons.people_alt,
      gradient: const LinearGradient(
        colors: [Color(0xFF50C878), Color(0xFF87CEEB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFF50C878),
    ),
    OnboardingData(
      title: '📊 Track Your Progress',
      description:
          'Monitor your mood, journal your thoughts, and see your mental health journey unfold with AI-powered insights.',
      icon: Icons.trending_up,
      gradient: const LinearGradient(
        colors: [Color(0xFF87CEEB), Color(0xFF4A90E2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFF87CEEB),
    ),
    OnboardingData(
      title: '🧘 Find Your Peace',
      description:
          'Start your wellness journey today. Every step forward is a step towards a healthier, happier mind.',
      icon: Icons.spa,
      gradient: const LinearGradient(
        colors: [Color(0xFF50C878), Color(0xFF4A90E2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFF50C878),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();

    // Auto-navigate to login after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2), // Professional blue
              Color(0xFF50C878), // Emerald green
              Color(0xFF87CEEB), // Sky blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Large Centered Logo Only
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60.0),
                child: Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 50,
                          offset: const Offset(0, 25),
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.4),
                          blurRadius: 35,
                          offset: const Offset(0, -12),
                          spreadRadius: 3,
                        ),
                        BoxShadow(
                          color: const Color(0xFF4A90E2).withValues(alpha: 0.4),
                          blurRadius: 60,
                          offset: const Offset(0, 30),
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: const Color(0xFF50C878).withValues(alpha: 0.3),
                          blurRadius: 70,
                          offset: const Offset(0, 0),
                          spreadRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo1.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
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
                    _animationController.reset();
                    _animationController.forward();
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      data: onboardingData[index],
                      fadeAnimation: _fadeAnimation,
                      scaleAnimation: _scaleAnimation,
                    );
                  },
                ),
              ),
              // Bottom Navigation
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip Button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Page Indicators
                    Row(
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? Colors.white
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    // Next/Get Started Button
                    ElevatedButton(
                      onPressed: () {
                        if (currentIndex == onboardingData.length - 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF667eea),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        currentIndex == onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

class OnboardingPage extends StatefulWidget {
  final OnboardingData data;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.fadeAnimation,
          child: ScaleTransition(
            scale: widget.scaleAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Icon Container
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: widget.data.gradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      widget.data.accentColor.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.data.icon,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    // Title
                    Text(
                      widget.data.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Description
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.data.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.6,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final Color accentColor;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.accentColor,
  });
}
