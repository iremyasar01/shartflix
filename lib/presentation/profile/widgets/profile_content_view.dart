import 'package:flutter/material.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/presentation/profile/widgets/favorite_movie.dart';
import 'package:shartflix/presentation/profile/widgets/profile_header.dart';

/// Profil sayfasının tüm görsel içeriğini ve düzenini yöneten widget.
class ProfileContentView extends StatelessWidget {
  final UserEntity user;

  const ProfileContentView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Tasarımdaki gibi özel bir AppBar
        SliverAppBar(
          backgroundColor: Colors.black,
          leading: const Icon(Icons.arrow_back, color: Colors.white),
          title: const Text('Profil Detayı', style: TextStyle(color: Colors.white)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                avatar: const Icon(Icons.diamond, color: Colors.white, size: 16),
                label: const Text('Sınırlı Teklif'),
                backgroundColor: Colors.red.shade700,
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ],
          pinned: true,
        ),
        // Geri kalan içeriği tek bir scroll listesi içine koyuyoruz.
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Bölüm: Profil Başlığı (Avatar, İsim, Buton)
                    ProfileHeader(user: user),
                    const SizedBox(height: 32),
                    // 2. Bölüm: Beğenilen Filmler
                    const FavoriteMoviesGrid(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
