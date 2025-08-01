import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/presentation/profile/bloc/profile_bloc.dart';
import 'package:shartflix/presentation/profile/screens/add_photo_screen.dart';

class AccountActionsSection extends StatelessWidget {
  final UserEntity user;

  const AccountActionsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildActionButton(
            context,
            icon: Icons.add_a_photo,
            label: 'Fotoğraf Ekle/Güncelle',
            onPressed: () => _navigateToAddPhoto(context, user),
          ),
          const Divider(height: 1),
          _buildActionButton(
            context,
            icon: Icons.favorite,
            label: 'Favori Filmlerim',
            onPressed: () {},
          ),
          const Divider(height: 1),
          _buildActionButton(
            context,
            icon: Icons.lock,
            label: 'Şifremi Değiştir',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        alignment: Alignment.centerLeft,
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

void _navigateToAddPhoto(BuildContext context, UserEntity user) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ProfileBloc>(context),
        child: AddPhotoScreen(user: user),
      ),
    ),
  );
}
}
