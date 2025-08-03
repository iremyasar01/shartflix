import 'package:flutter/material.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
class FavoriteMoviesGrid extends StatelessWidget {
  final List<Movie> movies; // Movie entity listesi

  const FavoriteMoviesGrid({super.key, required this.movies});

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
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie.production,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}