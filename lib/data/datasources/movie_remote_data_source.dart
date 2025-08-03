import 'package:dio/dio.dart';
import 'package:shartflix/data/models/movie_list_response_model.dart';
import 'package:shartflix/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponseModel> getMovies(int page);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<MovieListResponseModel> getMovies(int page) async {
    final response = await dio.get('/movie/list?page=$page');
    
    // API yanıtını Swagger formatına dönüştür
    final movies = (response.data['data']['movies'] as List)
        .map((movieJson) => MovieModel.fromJson(movieJson))
        .toList();

    return MovieListResponseModel(
      movies: movies,
      totalPages: response.data['data']['totalPages'] ?? 1,
      currentPage: response.data['data']['currentPage'] ?? page,
    );
  }
}