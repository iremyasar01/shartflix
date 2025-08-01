import 'package:flutter/material.dart';

// Örnek bir film modeli. Bunu kendi projenizdeki modelle değiştirebilirsiniz.
class _PlaceholderMovie {
  final String title;
  final String studio;
  final String imageUrl;
  _PlaceholderMovie(this.title, this.studio, this.imageUrl);
}

class FavoriteMoviesGrid extends StatelessWidget {
  const FavoriteMoviesGrid({super.key});

  // Gerçek veriler gelene kadar kullanılacak örnek filmler
  static final List<_PlaceholderMovie> _placeholderMovies = [
    _PlaceholderMovie('Aşk, Ekmek, Hayaller', 'Adam Yapım', 'https://placehold.co/400x600/222/fff?text=Film+1'),
    _PlaceholderMovie('Gece Karanlık', 'Fox Studios', 'https://placehold.co/400x600/333/fff?text=Film+2'),
    _PlaceholderMovie('Aşk, Ekmek, Hayaller', 'Adam Yapım', 'https://placehold.co/400x600/444/fff?text=Film+3'),
    _PlaceholderMovie('Gece Karanlık', 'Fox Studios', 'https://placehold.co/400x600/555/fff?text=Film+4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Beğendiğim Filmler',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Ana sayfayla birlikte scroll olması için
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Yan yana 2 film
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65, // Kartların en-boy oranı
          ),
          itemCount: _placeholderMovies.length,
          itemBuilder: (context, index) {
            final movie = _placeholderMovies[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      movie.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(movie.studio, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ],
            );
          },
        ),
      ],
    );
  }
}