import 'package:flutter/material.dart';

class JetonCard extends StatelessWidget {
  final String bonus;
  final String current;
  final String old;
  final String price;
  final Color color;

  const JetonCard({
    super.key,
    required this.bonus,
    required this.current,
    required this.old,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(bonus,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(old,
                style: const TextStyle(
                    color: Colors.white38,
                    decoration: TextDecoration.lineThrough)),
            Text(current,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(color: Colors.white)),
            const Text('Başına haftalık',
                style: TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
