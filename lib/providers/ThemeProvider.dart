import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners(); // Notifies all widgets listening for theme changes
  }

  ThemeData get currentTheme {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: AppTheme.primaryColor,
            checkboxTheme: CheckboxThemeData(
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
            ),
            radioTheme: RadioThemeData(
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
              trackColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: AppTheme.primaryColor,
            checkboxTheme: CheckboxThemeData(
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
            ),
            radioTheme: RadioThemeData(
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
              trackColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryColor;
                }
                return null;
              }),
            ),
          );
  }
}
