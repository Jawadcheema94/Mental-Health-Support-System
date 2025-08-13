import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/providers/ThemeProvider.dart';
import 'package:myapp/new_home_page.dart';
// import 'package:myapp/mood_journal.dart'; // Removed mood tracking
import 'package:myapp/user_appointments_screen.dart';
import 'package:myapp/settings.dart';

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final String userId;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.getSurfaceColor(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    onTap: () => _navigateToPage(context, 0),
                  ),
                  // Mood tracking removed
                  _buildNavItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    activeIcon: Icons.calendar_today_rounded,
                    label: 'Appointments',
                    index: 1,
                    onTap: () => _navigateToPage(context, 1),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings_rounded,
                    label: 'Settings',
                    index: 2,
                    onTap: () => _navigateToPage(context, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isSelected = currentIndex == index;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? themeProvider.getPrimaryColor().withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey(isSelected),
                    color: isSelected
                        ? themeProvider.getPrimaryColor()
                        : themeProvider.getTextSecondary(),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected
                        ? themeProvider.getPrimaryColor()
                        : themeProvider.getTextSecondary(),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    if (currentIndex == index) return;

    Widget page;
    switch (index) {
      case 0:
        page = NewHomeScreen(userId: userId);
        break;
      case 1:
        page = UserAppointmentsScreen(userId: userId, showBackButton: false);
        break;
      case 2:
        page = SettingsScreen(userId: userId);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}

// Wrapper widget to include bottom navigation
class ScreenWithBottomNav extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String userId;

  const ScreenWithBottomNav({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.getBackgroundColor(),
          body: this.child,
          bottomNavigationBar: ModernBottomNav(
            currentIndex: currentIndex,
            userId: userId,
          ),
        );
      },
    );
  }
}
