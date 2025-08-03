import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/presentation/profile/widgets/favorite_movie.dart';
import 'package:shartflix/presentation/profile/widgets/profile_header.dart';
import 'package:shartflix/presentation/profile/widgets/limited_offer_sheet.dart';

class ProfileContentView extends StatelessWidget {
  final UserEntity user;

  const ProfileContentView({super.key, required this.user});

  void _showLimitedOfferSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LimitedOfferSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Repository'yi context'ten al
    final movieRepository = Provider.of<MovieRepository>(context, listen: false);
    
    return FutureBuilder<List<Movie>>(
      future: movieRepository.getFavoriteMovies(), // Statik olmayan çağrı
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        }

        final favoriteMovies = snapshot.data ?? [];
        print('Favori filmler UI\'ya aktarılıyor: ${favoriteMovies.length} film');
        
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Profil Detayı', style: TextStyle(color: Colors.white)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () => _showLimitedOfferSheet(context),
                    child: Chip(
                      avatar: const Icon(Icons.diamond, color: Colors.white, size: 16),
                      label: const Text('Sınırlı Teklif'),
                      backgroundColor: Colors.red.shade700,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeader(user: user),
                        const SizedBox(height: 32),
                        FavoriteMoviesGrid(movies: favoriteMovies), // Favorileri geç
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}