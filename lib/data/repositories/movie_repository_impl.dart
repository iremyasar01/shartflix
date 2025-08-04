import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/data/datasources/movie_remote_data_source.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;


  MovieRepositoryImpl({
    required this.remoteDataSource,

  });

  @override
  Future<List<Movie>> getMovies(int page) async {
    final response = await remoteDataSource.getMovies(page);
  
    
    return response.movies.map((model) {
      return Movie(
        id: model.id,
        title: model.title,
        description: model.description,
        posterUrl: model.posterUrl,
        isFavorite: model.isFavorite,
        year: model.year!,
        director: model.director!,
        actors: model.actors!,
        production: model.production!,
      );
    }).toList();
  }

  // Favori durumunu değiştirme
  @override
  Future<void> toggleFavorite(String movieId) async {
    try {
      // API'ye favori durumunu değiştirme isteği gönder
      await remoteDataSource.toggleFavorite(movieId);
      
      
    } catch (e) {
      throw Exception('Favori güncellenemedi: ${e.toString()}');
    }
  }


  @override
  Future<List<Movie>> getFavoriteMovies() async {
    try {
       print('Favori filmler alınıyor...');
    final response = await remoteDataSource.getFavoriteMovies();
    print('${response.movies.length} favori film alındı');
     
      
      return response.movies.map((model) {
        return Movie(
          id: model.id,
          title: model.title,
          description: model.description,
          posterUrl: model.posterUrl,
          isFavorite: true,
          year: model.year!, 
          director: model.director!,
          actors: model.actors!,
          production: model.production!,
        );
      }).toList();
    } catch (e) {
      throw Exception('Favoriler yüklenemedi: ${e.toString()}');
    }
  }
}