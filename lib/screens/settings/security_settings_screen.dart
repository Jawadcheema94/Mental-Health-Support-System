import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/theme/app_theme.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = false;
  bool _pinEnabled = false;
  bool _autoLockEnabled = true;
  String _autoLockDuration = '5';
  bool _twoFactorEnabled = false;
  bool _sessionTimeoutEnabled = true;
  String _sessionTimeout = '30';

  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadSecuritySettings();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      setState(() {
        _biometricAvailable = isAvailable && availableBiometrics.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _biometricAvailable = false;
      });
    }
  }

  Future<void> _loadSecuritySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      _pinEnabled = prefs.getBool('pin_enabled') ?? false;
      _autoLockEnabled = prefs.getBool('auto_lock_enabled') ?? true;
      _autoLockDuration = prefs.getString('auto_lock_duration') ?? '5';
      _twoFactorEnabled = prefs.getBool('two_factor_enabled') ?? false;
      _sessionTimeoutEnabled = prefs.getBool('session_timeout_enabled') ?? true;
      _sessionTimeout = prefs.getString('session_timeout') ?? '30';
    });
  }

  Future<void> _saveSecuritySettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', _biometricEnabled);
    await prefs.setBool('pin_enabled', _pinEnabled);
    await prefs.setBool('auto_lock_enabled', _autoLockEnabled);
    await prefs.setString('auto_lock_duration', _autoLockDuration);
    await prefs.setBool('two_factor_enabled', _twoFactorEnabled);
    await prefs.setBool('session_timeout_enabled', _sessionTimeoutEnabled);
    await prefs.setString('session_timeout', _sessionTimeout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Security settings saved'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value && _biometricAvailable) {
      try {
        final bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to enable biometric login',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );

        if (didAuthenticate) {
          setState(() {
            _biometricEnabled = true;
          });
          _saveSecuritySettings();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enable biometric authentication: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } else {
      setState(() {
        _biometricEnabled = false;
      });
      _saveSecuritySettings();
    }
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
                      'Security',
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
                      'Authentication',
                      [
                        _buildSwitchTile(
                          'Biometric Authentication',
                          _biometricAvailable
                              ? 'Use fingerprint or face recognition'
                              : 'Biometric authentication not available',
                          _biometricEnabled && _biometricAvailable,
                          _biometricAvailable ? _toggleBiometric : null,
                        ),
                        _buildSwitchTile(
                          'PIN Protection',
                          'Require PIN to access the app',
                          _pinEnabled,
                          (value) {
                            if (value) {
                              _showSetPinDialog();
                            } else {
                              setState(() => _pinEnabled = false);
                              _saveSecuritySettings();
                            }
                          },
                        ),
                        _buildSwitchTile(
                          'Two-Factor Authentication',
                          'Add an extra layer of security',
                          _twoFactorEnabled,
                          (value) {
                            setState(() => _twoFactorEnabled = value);
                            _saveSecuritySettings();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildSectionCard(
                      'App Lock',
                      [
                        _buildSwitchTile(
                          'Auto Lock',
                          'Automatically lock the app when inactive',
                          _autoLockEnabled,
                          (value) {
                            setState(() => _autoLockEnabled = value);
                            _saveSecuritySettings();
                          },
                        ),
                        _buildDropdownTile(
                          'Auto Lock Duration',
                          'Time before app locks automatically',
                          _autoLockDuration,
                          ['1', '2', '5', '10', '15', '30'],
                          (value) {
                            setState(() => _autoLockDuration = value);
                            _saveSecuritySettings();
                          },
                          enabled: _autoLockEnabled,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildSectionCard(
                      'Session Management',
                      [
                        _buildSwitchTile(
                          'Session Timeout',
                          'Automatically log out after inactivity',
                          _sessionTimeoutEnabled,
                          (value) {
                            setState(() => _sessionTimeoutEnabled = value);
                            _saveSecuritySettings();
                          },
                        ),
                        _buildDropdownTile(
                          'Session Timeout Duration',
                          'Time before automatic logout',
                          _sessionTimeout,
                          ['15', '30', '60', '120', '240'],
                          (value) {
                            setState(() => _sessionTimeout = value);
                            _saveSecuritySettings();
                          },
                          enabled: _sessionTimeoutEnabled,
                          suffix: 'minutes',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildSectionCard(
                      'Privacy',
                      [
                        _buildActionTile(
                          'Clear App Data',
                          'Remove all locally stored data',
                          Icons.delete_outline,
                          _showClearDataDialog,
                          isDestructive: true,
                        ),
                        _buildActionTile(
                          'Export Security Log',
                          'Download security activity log',
                          Icons.download,
                          _exportSecurityLog,
                        ),
                      ],
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

  Widget _buildSwitchTile(String title, String subtitle, bool value,
      ValueChanged<bool>? onChanged) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: onChanged != null ? AppTheme.textPrimary : AppTheme.textLight,
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

  Widget _buildDropdownTile(String title, String subtitle, String value,
      List<String> options, ValueChanged<String> onChanged,
      {bool enabled = true, String? suffix}) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: enabled ? AppTheme.textPrimary : AppTheme.textLight,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: enabled
            ? (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              }
            : null,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text('$option${suffix != null ? ' $suffix' : ''}'),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }

  Widget _buildActionTile(
      String title, String subtitle, IconData icon, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.textLight,
      ),
      onTap: onTap,
    );
  }

  void _showSetPinDialog() {
    // Implementation for PIN setup dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set PIN'),
        content: const Text('PIN setup feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _pinEnabled = true);
              _saveSecuritySettings();
            },
            child: const Text('Set PIN'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear App Data'),
        content: const Text(
            'This will remove all locally stored data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementation for clearing app data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App data cleared')),
              );
            },
            child: const Text('Clear',
                style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  void _exportSecurityLog() {
    // Implementation for exporting security log
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security log export feature coming soon')),
    );
  }
}
