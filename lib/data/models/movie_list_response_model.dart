import 'package:shartflix/data/models/movie_model.dart';

class MovieListResponseModel {
  final List<MovieModel> movies;
  final int totalPages;
  final int currentPage;

  MovieListResponseModel({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });
}
