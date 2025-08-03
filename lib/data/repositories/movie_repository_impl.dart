import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/data/datasources/movie_remote_data_source.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final StorageService localStorage;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<List<Movie>> getMovies(int page) async {
    final response = await remoteDataSource.getMovies(page);
    final favoriteIds = await localStorage.getFavoriteMovieIds();
    
    return response.movies.map((model) {
      return Movie(
        id: model.id,
        title: model.title,
        description: model.description,
        posterUrl: model.posterUrl,
        isFavorite: favoriteIds.contains(model.id),
        year: model.year,
        director: model.director,
        actors: model.actors,
        production: model.production, // Yeni eklenen alan
      );
    }).toList();
  }
}

