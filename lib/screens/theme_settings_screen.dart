import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/providers/ThemeProvider.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.getBackgroundColor(),
          appBar: AppBar(
            title: Text(
              'Theme Settings',
              style: TextStyle(color: themeProvider.getTextPrimary()),
            ),
            backgroundColor: themeProvider.getPrimaryColor(),
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  decoration: BoxDecoration(
                    color: themeProvider.getSurfaceColor(),
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          color:
                              themeProvider.getPrimaryColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Icon(
                          Icons.palette,
                          color: themeProvider.getPrimaryColor(),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appearance',
                              style: AppTheme.headingMedium.copyWith(
                                color: themeProvider.getTextPrimary(),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Customize how MindEase looks',
                              style: AppTheme.bodyMedium.copyWith(
                                color: themeProvider.getTextSecondary(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),

                // Theme Options
                Text(
                  'Theme Mode',
                  style: AppTheme.headingSmall.copyWith(
                    color: themeProvider.getTextPrimary(),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),

                // Light Theme Option
                _buildThemeOption(
                  themeProvider,
                  AppThemeMode.light,
                  'Light Mode',
                  'Clean and bright interface',
                  Icons.light_mode,
                  Colors.orange,
                ),
                const SizedBox(height: AppTheme.spacingM),

                // Dark Theme Option
                _buildThemeOption(
                  themeProvider,
                  AppThemeMode.dark,
                  'Dark Mode',
                  'Easy on the eyes in low light',
                  Icons.dark_mode,
                  Colors.indigo,
                ),
                const SizedBox(height: AppTheme.spacingM),

                // System Theme Option
                _buildThemeOption(
                  themeProvider,
                  AppThemeMode.system,
                  'System Default',
                  'Follows your device settings',
                  Icons.settings_system_daydream,
                  Colors.green,
                ),
                const SizedBox(height: AppTheme.spacingL),

                // Color Scheme Preview
                Text(
                  'Color Preview',
                  style: AppTheme.headingSmall.copyWith(
                    color: themeProvider.getTextPrimary(),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),

                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  decoration: BoxDecoration(
                    color: themeProvider.getSurfaceColor(),
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildColorSwatch(
                            themeProvider,
                            'Primary',
                            themeProvider.getPrimaryColor(),
                          ),
                          _buildColorSwatch(
                            themeProvider,
                            'Success',
                            AppTheme.successColor,
                          ),
                          _buildColorSwatch(
                            themeProvider,
                            'Warning',
                            AppTheme.warningColor,
                          ),
                          _buildColorSwatch(
                            themeProvider,
                            'Error',
                            AppTheme.errorColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          gradient: themeProvider.getPrimaryGradient(),
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: const Center(
                          child: Text(
                            'MindEase Gradient',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeTheme(
      ThemeProvider themeProvider, AppThemeMode mode) async {
    await themeProvider.setThemeMode(mode);

    // Show confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Theme changed to ${_getThemeDisplayName(mode)}'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
        ),
      );
    }
  }

  String _getThemeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light Mode';
      case AppThemeMode.dark:
        return 'Dark Mode';
      case AppThemeMode.system:
        return 'System Default';
    }
  }

  Widget _buildThemeOption(
    ThemeProvider themeProvider,
    AppThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    final isSelected = themeProvider.themeMode == mode;

    return GestureDetector(
      onTap: () => _changeTheme(themeProvider, mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: themeProvider.getSurfaceColor(),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: isSelected
                ? themeProvider.getPrimaryColor()
                : themeProvider.getBorderColor(),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: themeProvider.getPrimaryColor().withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : AppTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      color: themeProvider.getTextPrimary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.bodySmall.copyWith(
                      color: themeProvider.getTextSecondary(),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: themeProvider.getPrimaryColor(),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatch(
      ThemeProvider themeProvider, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: themeProvider.getTextSecondary(),
          ),
        ),
      ],
    );
  }
}
