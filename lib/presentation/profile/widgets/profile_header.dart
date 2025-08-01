import 'package:flutter/material.dart';
import 'package:shartflix/domain/entities/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: user.photoUrl != null && user.photoUrl!.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl!),
                  radius: 60,
                )
              : const Icon(Icons.person, size: 40, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}