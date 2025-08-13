import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/theme/app_theme.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  bool _isDarkMode = false;
  static const String _themeModeKey = 'theme_mode';

  AppThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  // Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_themeModeKey);

      if (savedThemeMode != null) {
        _themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedThemeMode,
          orElse: () => AppThemeMode.system,
        );
      }

      _updateDarkMode();
      notifyListeners();
    } catch (e) {
      print('Error loading theme mode: $e');
    }
  }

  // Save theme mode to SharedPreferences
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, _themeMode.toString());
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }

  // Update dark mode based on theme mode and system settings
  void _updateDarkMode() {
    switch (_themeMode) {
      case AppThemeMode.light:
        _isDarkMode = false;
        break;
      case AppThemeMode.dark:
        _isDarkMode = true;
        break;
      case AppThemeMode.system:
        // Get system brightness
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        _isDarkMode = brightness == Brightness.dark;
        break;
    }
  }

  // Set theme mode and persist it
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      _updateDarkMode();
      await _saveThemeMode();
      notifyListeners();
    }
  }

  // Legacy methods for backward compatibility
  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? AppThemeMode.dark : AppThemeMode.light);
  }

  Future<void> setLightMode() async {
    await setThemeMode(AppThemeMode.light);
  }

  Future<void> setDarkMode() async {
    await setThemeMode(AppThemeMode.dark);
  }

  Future<void> setSystemMode() async {
    await setThemeMode(AppThemeMode.system);
  }

  ThemeData get currentTheme {
    return _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  // Helper method to get theme-aware colors
  Color getBackgroundColor() => AppTheme.getBackgroundColor(_isDarkMode);
  Color getSurfaceColor() => AppTheme.getSurfaceColor(_isDarkMode);
  Color getCardColor() => AppTheme.getCardColor(_isDarkMode);
  Color getTextPrimary() => AppTheme.getTextPrimary(_isDarkMode);
  Color getTextSecondary() => AppTheme.getTextSecondary(_isDarkMode);
  Color getTextLight() => AppTheme.getTextLight(_isDarkMode);
  Color getBorderColor() => AppTheme.getBorderColor(_isDarkMode);
  Color getPrimaryColor() => AppTheme.getPrimaryColor(_isDarkMode);
  Color getSecondaryColor() => AppTheme.getSecondaryColor(_isDarkMode);
  Color getAccentColor() => AppTheme.getAccentColor(_isDarkMode);

  LinearGradient getPrimaryGradient() =>
      AppTheme.getPrimaryGradient(_isDarkMode);
  LinearGradient getBackgroundGradient() =>
      AppTheme.getBackgroundGradient(_isDarkMode);
  LinearGradient getCardGradient() => AppTheme.getCardGradient(_isDarkMode);
  LinearGradient getHeroGradient() => AppTheme.getHeroGradient(_isDarkMode);
}
