import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  String _currentLanguage = 'en';
  String get currentLanguage => _currentLanguage;

  final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      // App General
      'app_name': 'MindEase',
      'welcome': 'Welcome',
      'login': 'Login',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'save': 'Save',
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      
      // Settings
      'settings': 'Settings',
      'update_profile': 'Update Profile',
      'change_password': 'Change Password',
      'payment_methods': 'Payment Methods',
      'notifications': 'Notifications',
      'theme': 'Theme',
      'language': 'Language',
      'security': 'Security',
      'about': 'About',
      'support': 'Support',
      
      // Profile
      'profile': 'Profile',
      'name': 'Name',
      'email': 'Email',
      'phone': 'Phone',
      'address': 'Address',
      'profile_updated': 'Profile updated successfully',
      
      // Password
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm Password',
      'password_changed': 'Password changed successfully',
      
      // Notifications
      'push_notifications': 'Push Notifications',
      'appointment_reminders': 'Appointment Reminders',
      'mood_reminders': 'Mood Reminders',
      'notification_settings_saved': 'Notification settings saved',
      
      // Theme
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'appearance': 'Appearance',
      
      // Language
      'select_language': 'Select Language',
      'language_changed': 'Language changed successfully',
      
      // About
      'about_mindease': 'About MindEase',
      'version': 'Version',
      'contact_info': 'Contact Information',
      
      // Support
      'contact_support': 'Contact Support',
      'faq': 'Frequently Asked Questions',
      'help_resources': 'Help Resources',
    },
    'ur': {
      // App General
      'app_name': 'مائنڈ ایز',
      'welcome': 'خوش آمدید',
      'login': 'لاگ ان',
      'signup': 'سائن اپ',
      'logout': 'لاگ آؤٹ',
      'save': 'محفوظ کریں',
      'cancel': 'منسوخ',
      'ok': 'ٹھیک ہے',
      'yes': 'ہاں',
      'no': 'نہیں',
      'loading': 'لوڈ ہو رہا ہے...',
      'error': 'خرابی',
      'success': 'کامیابی',
      
      // Settings
      'settings': 'ترتیبات',
      'update_profile': 'پروفائل اپڈیٹ کریں',
      'change_password': 'پاس ورڈ تبدیل کریں',
      'payment_methods': 'ادائیگی کے طریقے',
      'notifications': 'اطلاعات',
      'theme': 'تھیم',
      'language': 'زبان',
      'security': 'سیکیورٹی',
      'about': 'کے بارے میں',
      'support': 'سپورٹ',
      
      // Profile
      'profile': 'پروفائل',
      'name': 'نام',
      'email': 'ای میل',
      'phone': 'فون',
      'address': 'پتہ',
      'profile_updated': 'پروفائل کامیابی سے اپڈیٹ ہوا',
      
      // Password
      'current_password': 'موجودہ پاس ورڈ',
      'new_password': 'نیا پاس ورڈ',
      'confirm_password': 'پاس ورڈ کی تصدیق',
      'password_changed': 'پاس ورڈ کامیابی سے تبدیل ہوا',
      
      // Notifications
      'push_notifications': 'پش اطلاعات',
      'appointment_reminders': 'اپائنٹمنٹ یاد دہانی',
      'mood_reminders': 'موڈ یاد دہانی',
      'notification_settings_saved': 'اطلاعات کی ترتیبات محفوظ ہوئیں',
      
      // Theme
      'light_mode': 'ہلکا موڈ',
      'dark_mode': 'گہرا موڈ',
      'appearance': 'ظاہری شکل',
      
      // Language
      'select_language': 'زبان منتخب کریں',
      'language_changed': 'زبان کامیابی سے تبدیل ہوئی',
      
      // About
      'about_mindease': 'مائنڈ ایز کے بارے میں',
      'version': 'ورژن',
      'contact_info': 'رابطے کی معلومات',
      
      // Support
      'contact_support': 'سپورٹ سے رابطہ',
      'faq': 'اکثر پوچھے جانے والے سوالات',
      'help_resources': 'مدد کے وسائل',
    },
  };

  String translate(String key) {
    return _localizedStrings[_currentLanguage]?[key] ?? key;
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_localizedStrings.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', languageCode);
      notifyListeners();
    }
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('selected_language') ?? 'en';
    notifyListeners();
  }

  bool get isRTL => _currentLanguage == 'ur';
}
