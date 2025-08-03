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
 /* factory MovieListResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieListResponseModel(
      movies: (json['movies'] as List)
          .map((e) => MovieModel.fromJson(e))
          .toList(),
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
    );
  }
}
*/