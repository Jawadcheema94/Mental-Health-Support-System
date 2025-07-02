import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class InsomniaScreen extends StatelessWidget {
  const InsomniaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern App Bar
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppTheme.radiusXL),
                    bottomRight: Radius.circular(AppTheme.radiusXL),
                  ),
                  boxShadow: AppTheme.mediumShadow,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: Text(
                        'Insomnia Information',
                        style: AppTheme.headingMedium.copyWith(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                      isSmallScreen ? AppTheme.spacingS : AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        'What is Insomnia?',
                        'Insomnia is a sleep disorder that makes it difficult to fall asleep, stay asleep, or get quality sleep. It can be short-term (acute) or long-term (chronic).',
                        Icons.bedtime_rounded,
                        AppTheme.primaryColor,
                        isSmallScreen,
                      ),
                      SizedBox(
                          height: isSmallScreen
                              ? AppTheme.spacingM
                              : AppTheme.spacingL),
                      _buildInfoCard(
                        'Common Symptoms',
                        '• Difficulty falling asleep\n'
                            '• Waking up frequently during the night\n'
                            '• Waking up too early\n'
                            '• Feeling unrefreshed after sleep\n'
                            '• Daytime fatigue or sleepiness\n'
                            '• Irritability or mood changes\n'
                            '• Trouble concentrating',
                        Icons.warning_rounded,
                        AppTheme.warningColor,
                        isSmallScreen,
                      ),
                      SizedBox(
                          height: isSmallScreen
                              ? AppTheme.spacingM
                              : AppTheme.spacingL),
                      _buildInfoCard(
                        'Possible Causes',
                        '• Stress or anxiety\n'
                            '• Poor sleep habits (e.g., irregular sleep schedule)\n'
                            '• Medical conditions (e.g., chronic pain, asthma)\n'
                            '• Medications or substance use (e.g., caffeine, alcohol)\n'
                            '• Mental health disorders (e.g., depression)\n'
                            '• Environmental factors (e.g., noise, light)',
                        Icons.search_rounded,
                        AppTheme.secondaryColor,
                        isSmallScreen,
                      ),
                      SizedBox(
                          height: isSmallScreen
                              ? AppTheme.spacingM
                              : AppTheme.spacingL),
                      _buildInfoCard(
                        'Effects & Consequences',
                        '• Decreased cognitive function (e.g., memory issues)\n'
                            '• Increased risk of accidents or injuries\n'
                            '• Mood disturbances (e.g., irritability, anxiety)\n'
                            '• Weakened immune system\n'
                            '• Higher risk of chronic diseases (e.g., diabetes)\n'
                            '• Reduced quality of life',
                        Icons.health_and_safety_rounded,
                        AppTheme.errorColor,
                        isSmallScreen,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon,
      Color color, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.softShadow,
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            isSmallScreen ? AppTheme.spacingM : AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.headingSmall.copyWith(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: isSmallScreen ? AppTheme.spacingS : AppTheme.spacingM),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Text(
                content,
                style: AppTheme.bodyMedium.copyWith(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
