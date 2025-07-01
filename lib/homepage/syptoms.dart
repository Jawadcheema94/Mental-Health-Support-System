import 'package:flutter/material.dart';

class _SymptomTag extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSmallScreen;

  const _SymptomTag({
    required this.label,
    this.onTap,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.purple.withOpacity(0.1),
        labelStyle: TextStyle(
          color: Colors.purple,
          fontSize: isSmallScreen ? 12 : 14,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 2 : 4,
        ),
      ),
    );
  }
}