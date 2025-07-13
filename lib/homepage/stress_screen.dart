import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class StressScreen extends StatelessWidget {
  const StressScreen({super.key});

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
                        'Stress Information',
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
                        content: '• Irritability or mood swings\n'
                            '• Headaches or muscle tension\n'
                            '• Fatigue or low energy\n'
                            '• Difficulty sleeping\n'
                            '• Racing thoughts or feeling overwhelmed\n'
                            '• Digestive issues (e.g., stomach aches)\n'
                            '• Changes in appetite\n'
                            '• Trouble concentrating',
                        icon: Icons.psychology,
                        isSmallScreen: isSmallScreen,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildInfoCard(
                        context,
                        title: 'Causes',
                        content: '• Work or academic pressure\n'
                            '• Financial difficulties\n'
                            '• Relationship conflicts\n'
                            '• Major life changes (e.g., moving, job loss)\n'
                            '• Health problems\n'
                            '• Lack of work-life balance',
                        icon: Icons.science,
                        isSmallScreen: isSmallScreen,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildInfoCard(
                        context,
                        title: 'Effects',
                        content: '• Weakened immune system\n'
                            '• Increased risk of anxiety or depression\n'
                            '• Burnout or chronic fatigue\n'
                            '• Strained personal relationships\n'
                            '• Poor decision-making\n'
                            '• Physical health issues (e.g., high blood pressure)',
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
