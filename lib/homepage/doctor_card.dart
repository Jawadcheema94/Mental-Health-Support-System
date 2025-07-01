import 'package:flutter/material.dart';

class _DoctorCard extends StatelessWidget {
  final String name;
  final String rating;
  final String specialty;
  final double cardWidth;
  final bool isSmallScreen;

  const _DoctorCard({
    required this.name,
    required this.rating,
    required this.specialty,
    required this.cardWidth,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: isSmallScreen ? 25 : 30,
                child: Image.asset(
                  'assets/images/user.png',
                  width: isSmallScreen ? 40 : 50,
                  height: isSmallScreen ? 40 : 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                specialty,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: isSmallScreen ? 14 : 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}