import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const SocialButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade800.withOpacity(0.5),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}