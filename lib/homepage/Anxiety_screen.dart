import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class AnxietyScreen extends StatelessWidget {
  const AnxietyScreen({super.key});

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
                        'Anxiety Information',
                        style: AppTheme.headingMedium.copyWith(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spacingL),
                      _buildInfoCard(
                        context,
                        title: 'Symptoms',
                        content: '• Excessive worry or fear\n'
                            '• Restlessness or feeling on edge\n'
                            '• Rapid heartbeat or palpitations\n'
                            '• Sweating or trembling\n'
                            '• Difficulty concentrating\n'
                            '• Muscle tension\n'
                            '• Sleep disturbances\n'
                            '• Panic attacks (sudden intense fear)',
                        icon: Icons.psychology,
                        isSmallScreen: isSmallScreen,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildInfoCard(
                        context,
                        title: 'Causes',
                        content:
                            '• Genetic factors (family history of anxiety)\n'
                            '• Brain chemistry imbalances\n'
                            '• Traumatic or stressful life events\n'
                            '• Chronic medical conditions\n'
                            '• Substance use or withdrawal\n'
                            '• Personality traits (e.g., perfectionism)',
                        icon: Icons.science,
                        isSmallScreen: isSmallScreen,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildInfoCard(
                        context,
                        title: 'Effects',
                        content:
                            '• Social isolation and strained relationships\n'
                            '• Reduced productivity at work or school\n'
                            '• Physical health issues (e.g., headaches, digestive problems)\n'
                            '• Increased risk of depression\n'
                            '• Chronic fatigue from poor sleep\n'
                            '• Avoidance behaviors impacting daily life',
                        icon: Icons.warning,
                        isSmallScreen: isSmallScreen,
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

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required bool isSmallScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.softShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Text(
                  title,
                  style: AppTheme.headingSmall.copyWith(
                    fontSize: isSmallScreen ? 16 : 18,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              content,
              style: AppTheme.bodyMedium.copyWith(
                fontSize: isSmallScreen ? 12 : 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
