import 'package:flutter/material.dart';
import 'package:shartflix/domain/entities/user_entity.dart';

class ProfileInfoSection extends StatelessWidget {
  final UserEntity user;

  const ProfileInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hesap Bilgileri',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            //_buildInfoRow('Kullanıcı ID', user.id ?? 'Belirtilmemiş'),
            const SizedBox(height: 12),
            _buildInfoRow('Kayıt Tarihi', '01.01.2023'), // Örnek veri
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}