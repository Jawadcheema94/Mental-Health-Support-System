import 'package:flutter/material.dart';

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final bool isSmallScreen;

  const _SectionHeader({
    required this.title,
    this.onSeeAll,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            "See all",
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}