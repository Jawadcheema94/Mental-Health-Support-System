import 'package:flutter/material.dart';
import 'admin_login.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MindEaseAdminApp());
}

class MindEaseAdminApp extends StatelessWidget {
  const MindEaseAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindEase Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AdminLoginScreen(),
    );
  }
}
