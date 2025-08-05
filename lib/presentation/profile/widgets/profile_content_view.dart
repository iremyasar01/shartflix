import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/presentation/profile/widgets/favorite_movie.dart';
import 'package:shartflix/presentation/profile/widgets/profile_header.dart';
import 'package:shartflix/presentation/profile/widgets/limited_offer_sheet.dart';

class ProfileContentView extends StatefulWidget {
  final UserEntity user;

  const ProfileContentView({super.key, required this.user});

  @override
  State<ProfileContentView> createState() => _ProfileContentViewState();
}

class _ProfileContentViewState extends State<ProfileContentView> {
  late Future<List<Movie>> _favoriteMoviesFuture;
  late MovieRepository _movieRepository;

  @override
  void initState() {
    super.initState();
    _movieRepository = Provider.of<MovieRepository>(context, listen: false);
    _favoriteMoviesFuture = _movieRepository.getFavoriteMovies();
  }

  void _showLimitedOfferSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LimitedOfferSheet(),
    );
  }

  // Favori filmleri yenileme fonksiyonu
  Future<void> _refreshFavoriteMovies() async {
    print('Favori filmler yenileniyor...');
    setState(() {
      _favoriteMoviesFuture = _movieRepository.getFavoriteMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _favoriteMoviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hata: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshFavoriteMovies,
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            ),
          );
        }

        final favoriteMovies = snapshot.data ?? [];
        print('Favori filmler UI\'ya aktarılıyor: ${favoriteMovies.length} film');

        return Scaffold(
          backgroundColor: Colors.black,
          body: RefreshIndicator(
            onRefresh: _refreshFavoriteMovies,
            color: Colors.red,
            backgroundColor: Colors.white,
            child: CustomScrollView(
              // Bu önemli: RefreshIndicator'ın çalışması için
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'Profil Detayı',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    // Refresh butonu
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _refreshFavoriteMovies,
                      tooltip: 'Favori filmleri yenile',
                    ),
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
                  expandedHeight: 80,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileHeader(user: widget.user),
                            const SizedBox(height: 32),
                            FavoriteMoviesGrid(movies: favoriteMovies),
                            // Alt boşluk - pull to refresh için
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}