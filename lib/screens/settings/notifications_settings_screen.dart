import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/theme/app_theme.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _appointmentReminders = true;
  bool _moodReminders = true;
  bool _journalReminders = true;
  bool _therapistMessages = true;
  bool _systemUpdates = false;
  bool _marketingEmails = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _reminderTime = '09:00';

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _appointmentReminders = prefs.getBool('appointment_reminders') ?? true;
      _moodReminders = prefs.getBool('mood_reminders') ?? true;
      _journalReminders = prefs.getBool('journal_reminders') ?? true;
      _therapistMessages = prefs.getBool('therapist_messages') ?? true;
      _systemUpdates = prefs.getBool('system_updates') ?? false;
      _marketingEmails = prefs.getBool('marketing_emails') ?? false;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _reminderTime = prefs.getString('reminder_time') ?? '09:00';
    });
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('appointment_reminders', _appointmentReminders);
    await prefs.setBool('mood_reminders', _moodReminders);
    await prefs.setBool('journal_reminders', _journalReminders);
    await prefs.setBool('therapist_messages', _therapistMessages);
    await prefs.setBool('system_updates', _systemUpdates);
    await prefs.setBool('marketing_emails', _marketingEmails);
    await prefs.setBool('sound_enabled', _soundEnabled);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
    await prefs.setString('reminder_time', _reminderTime);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.surfaceColor,
                        foregroundColor: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Text(
                      'Notifications',
                      style: AppTheme.headingLarge.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  children: [
                    _buildSectionCard(
                      'Push Notifications',
                      [
                        _buildSwitchTile(
                          'Enable Push Notifications',
                          'Receive notifications on your device',
                          _pushNotifications,
                          (value) => setState(() => _pushNotifications = value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    _buildSectionCard(
                      'Reminders',
                      [
                        _buildSwitchTile(
                          'Appointment Reminders',
                          'Get notified about upcoming appointments',
                          _appointmentReminders,
                          (value) => setState(() => _appointmentReminders = value),
                        ),
                        _buildSwitchTile(
                          'Mood Check-in Reminders',
                          'Daily reminders to track your mood',
                          _moodReminders,
                          (value) => setState(() => _moodReminders = value),
                        ),
                        _buildSwitchTile(
                          'Journal Reminders',
                          'Reminders to write in your journal',
                          _journalReminders,
                          (value) => setState(() => _journalReminders = value),
                        ),
                        _buildTimeTile(
                          'Reminder Time',
                          'Set your preferred reminder time',
                          _reminderTime,
                          _selectReminderTime,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    _buildSectionCard(
                      'Messages',
                      [
                        _buildSwitchTile(
                          'Therapist Messages',
                          'Notifications from your therapist',
                          _therapistMessages,
                          (value) => setState(() => _therapistMessages = value),
                        ),
                        _buildSwitchTile(
                          'System Updates',
                          'App updates and maintenance notifications',
                          _systemUpdates,
                          (value) => setState(() => _systemUpdates = value),
                        ),
                        _buildSwitchTile(
                          'Marketing Emails',
                          'Promotional content and tips',
                          _marketingEmails,
                          (value) => setState(() => _marketingEmails = value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    _buildSectionCard(
                      'Sound & Vibration',
                      [
                        _buildSwitchTile(
                          'Sound',
                          'Play sound for notifications',
                          _soundEnabled,
                          (value) => setState(() => _soundEnabled = value),
                        ),
                        _buildSwitchTile(
                          'Vibration',
                          'Vibrate for notifications',
                          _vibrationEnabled,
                          (value) => setState(() => _vibrationEnabled = value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXL),
                    
                    // Save Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveNotificationSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save Settings',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Text(
              title,
              style: AppTheme.headingSmall.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildTimeTile(String title, String subtitle, String time, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.textLight,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_reminderTime.split(':')[0]),
        minute: int.parse(_reminderTime.split(':')[1]),
      ),
    );
    
    if (picked != null) {
      setState(() {
        _reminderTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }
}
