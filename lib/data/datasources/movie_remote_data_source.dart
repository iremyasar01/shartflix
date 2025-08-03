import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shartflix/data/models/movie_list_response_model.dart';
import 'package:shartflix/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponseModel> getMovies(int page);
   // Favori durumunu değiştirme
  Future<void> toggleFavorite(String movieId);
  
  // Favori filmleri getirme
  Future<MovieListResponseModel> getFavoriteMovies();
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
    @override
  Future<void> toggleFavorite(String movieId) async {
    final response = await dio.post('/movie/favorite/$movieId');
    
    if (response.data['success'] != true) {
      throw Exception('Favori işlemi başarısız: ${response.data['message']}');
    }
  }
@override
Future<MovieListResponseModel> getFavoriteMovies() async {
  try {
    final response = await dio.get('/movie/favorites');
    
    // HTTP durum kodunu kontrol et
    if (response.statusCode != 200) {
      throw Exception('HTTP hatası: ${response.statusCode}');
    }

    // Yanıt verisini logla (debug için)
    print('API Yanıt Verisi: ${response.data}');
    print('Yanıt Tipi: ${response.data.runtimeType}');

    // Yanıtın temel yapısını kontrol et
    if (response.data == null) {
      throw Exception('Boş yanıt alındı');
    }

    dynamic responseData = response.data;
    List<dynamic> moviesData = [];

    // Senaryo 1: Doğrudan liste olarak geliyorsa
    if (responseData is List) {
      moviesData = responseData;
    } 
    // Senaryo 2: {"movies": [...]} formatında geliyorsa
    else if (responseData is Map) {
      // Olası anahtar varyasyonlarını deneyelim
      final possibleKeys = ['movies', 'data', 'items', 'results'];
      bool found = false;
      
      for (final key in possibleKeys) {
        if (responseData.containsKey(key) && responseData[key] is List) {
          moviesData = responseData[key] as List;
          found = true;
          break;
        }
      }
      
      if (!found) {
        // Map içindeki tüm liste değerlerini ara
        final allLists = responseData.values.where((value) => value is List).toList();
        
        if (allLists.isNotEmpty) {
          // İlk liste değerini kullan
          moviesData = allLists.first as List;
          print('Uyarı: Standart olmayan anahtar kullanıldı. Listeyi bulduk: ${allLists.length} liste var');
        } else {
          throw Exception('Yanıtta "movies" veya benzeri anahtar bulunamadı ve liste içermiyor');
        }
      }
    }
    // Senaryo 3: String olarak geliyorsa (nadir)
    else if (responseData is String) {
      try {
        // JSON string olarak gelmiş olabilir
        final parsed = json.decode(responseData);
        if (parsed is List) {
          moviesData = parsed;
        } else if (parsed is Map && parsed.containsKey('movies')) {
          moviesData = parsed['movies'] as List;
        }
      } catch (e) {
        throw Exception('String yanıt JSON olarak ayrıştırılamadı');
      }
    }
    // Desteklenmeyen format
    else {
      throw Exception('Bilinmeyen yanıt formatı: ${responseData.runtimeType}');
    }

    // Film listesini oluştur (hata toleranslı)
    final movies = moviesData.map((item) {
      try {
        if (item is Map<String, dynamic>) {
          return MovieModel.fromJson(item);
        } 
        else if (item is Map) {
          // Map<String, dynamic> olmayan map'leri dönüştür
          return MovieModel.fromJson(Map<String, dynamic>.from(item));
        }
        else if (item is String) {
          // Sadece ID geliyorsa
          return MovieModel(
            id: item,
            title: "Bilinmeyen Film",
            description: "",
            posterUrl: ""
          );
        }
        else {
          throw Exception('Geçersiz film veri tipi: ${item.runtimeType}');
        }
      } catch (e) {
        print('Film dönüştürme hatası: $e\nVeri: $item');
        return MovieModel(
          id: "hata",
          title: "Hatalı Film Verisi",
          description: "",
          posterUrl: ""
        );
      }
    }).toList();

    return MovieListResponseModel(
      movies: movies.where((m) => m.id != "hata").toList(),
      totalPages: 1,
      currentPage: 1,
    );
  } on DioException catch (dioError) {
    final errorMessage = dioError.response?.data?['message'] ?? dioError.message;
    throw Exception('API hatası: $errorMessage');
  } catch (e) {
    throw Exception('Favoriler alınırken hata: $e');
  }
}
}