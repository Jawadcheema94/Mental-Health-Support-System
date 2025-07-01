import 'package:flutter/material.dart';

class _TopDoctorCard extends StatelessWidget {
  final String name;
  final String rating;
  final String reviews;
  final String specialty;
  final bool isSmallScreen;

  const _TopDoctorCard({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.specialty,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: isSmallScreen ? 25 : 30,
              child: Image.asset(
                'assets/images/girl.png',
                width: isSmallScreen ? 40 : 50,
                height: isSmallScreen ? 40 : 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: isSmallScreen ? 14 : 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$rating ($reviews)",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.favorite_border, color: Colors.purple),
          ],
        ),
      ),
    );
  }
}