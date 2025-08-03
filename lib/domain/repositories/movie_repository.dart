import 'package:shartflix/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies(int page);
}