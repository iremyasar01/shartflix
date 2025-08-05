import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/presentation/movie/bloc/movie_list_bloc.dart';
import 'package:shartflix/presentation/movie/bloc/movie_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieGridItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieGridItem({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) {
        // State'den güncel movie'yi al
        final currentMovie = state.movies.firstWhere(
          (m) => m.id == movie.id,
          orElse: () => movie,
        );
        
        return GestureDetector(
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Film posteri
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: currentMovie.posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.movie)),
                      ),
                    ),
                  ),
                ),
                
                // Film bilgileri
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentMovie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentMovie.year,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Favori butonu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          currentMovie.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: currentMovie.isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          print('Favori butonu basıldı - Movie: ${currentMovie.title}, ID: ${currentMovie.id}, Current: ${currentMovie.isFavorite}');
                          
                          // Favori işlemini tetikle
                          context.read<MovieListBloc>().add(
                            ToggleFavorite(currentMovie.id)
                          );
                        },
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