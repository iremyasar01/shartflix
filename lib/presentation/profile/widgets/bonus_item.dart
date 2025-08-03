import 'package:flutter/material.dart';
class BonusItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const BonusItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.pinkAccent, size: 32),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
