

import 'package:dio/dio.dart';
import 'package:shartflix/data/models/movie_list_response_model.dart';
import 'package:shartflix/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponseModel> getMovies(int page);
  // Favori durumunu değiştirme - güncellenmiş movie nesnesini döndür
  Future<MovieModel> toggleFavorite(String movieId);
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
  Future<MovieModel> toggleFavorite(String movieId) async {
    try {
      print('Favori toggle işlemi başlatılıyor - Movie ID: $movieId');
      
      final response = await dio.post('/movie/favorite/$movieId');
      
      print('Toggle API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');
      
      // Farklı API response formatlarını handle et
      dynamic responseData = response.data;
      
      // Format 1: {"success": true, "message": "...", "data": {...}}
      if (responseData is Map && responseData.containsKey('success')) {
        if (responseData['success'] == true) {
          // Eğer response'da movie data'sı varsa direkt kullan
          if (responseData['data'] != null) {
            if (responseData['data'] is Map) {
              return MovieModel.fromJson(Map<String, dynamic>.from(responseData['data']));
            }
          }
          
          // API sadece başarı mesajı döndürüyorsa, mevcut movie'yi bulup isFavorite'i toggle et
          // Bu durumda optimistic update yapıyoruz
          print('API sadece başarı mesajı döndürdü, optimistic update yapılıyor');
          
          // Burada tam movie bilgisi yoksa, en azından movieId'yi kullanarak bir dummy movie oluştur
          // Gerçek uygulamada BLoC'un elindeki mevcut movie'yi kullanacağız
          return MovieModel(
            id: movieId,
            title: 'Updated Movie', // Bu geçici, BLoC'da gerçek movie ile replace edilecek
            description: '',
            posterUrl: '',
            isFavorite: true, // Bu da geçici, BLoC toggle işlemini yapacak
          );
        } else {
          final errorMessage = responseData['message'] ?? 'Bilinmeyen API hatası';
          throw Exception('Favori işlemi başarısız: $errorMessage');
        }
      }
      // Format 2: HTTP 200 OK ve boş response body (sadece status code önemli)
      else if (response.statusCode == 200) {
        print('HTTP 200 OK alındı, işlem başarılı sayılıyor');
        return MovieModel(
          id: movieId,
          title: 'Updated Movie',
          description: '',
          posterUrl: '',
          isFavorite: true,
        );
      }
      // Format 3: Diğer durumlar
      else {
        throw Exception('Beklenmeyen API yanıt formatı: ${responseData.runtimeType}');
      }
      
    } on DioException catch (dioError) {
      print('DioException yakalandı: ${dioError.response?.statusCode}');
      print('Error Response Data: ${dioError.response?.data}');
      
      String errorMessage = 'API bağlantı hatası';
      
      if (dioError.response != null) {
        final responseData = dioError.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is String) {
          errorMessage = responseData;
        } else {
          errorMessage = 'HTTP ${dioError.response!.statusCode} hatası';
        }
      } else if (dioError.message != null) {
        errorMessage = dioError.message!;
      }
      
      throw Exception('API hatası: $errorMessage');
    } catch (e) {
      print('Genel hata yakalandı: $e');
      rethrow;
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
      print('Favori API Yanıt Verisi: ${response.data}');

      // Yanıtın temel yapısını kontrol et
      if (response.data == null) {
        throw Exception('Boş yanıt alındı');
      }

      dynamic responseData = response.data;
      List<dynamic> moviesData = [];

      // API'den gelen veri formatını analiz et
      if (responseData is Map && responseData.containsKey('success')) {
        // Standart API formatı: {"success": true, "data": {...}}
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          
          if (data is List) {
            moviesData = data;
          } else if (data is Map) {
            // Nested yapı: {"data": {"movies": [...]}} veya {"data": {"favorites": [...]}}
            final possibleKeys = ['movies', 'favorites', 'items', 'results'];
            bool found = false;
            
            for (final key in possibleKeys) {
              if (data.containsKey(key) && data[key] is List) {
                moviesData = data[key] as List;
                found = true;
                break;
              }
            }
            
            if (!found) {
              throw Exception('Favori filmler listesi bulunamadı. API formatı: ${data.keys}');
            }
          }
        } else {
          throw Exception('API hatası: ${responseData['message'] ?? 'Bilinmeyen hata'}');
        }
      }
      // Doğrudan liste olarak geliyorsa
      else if (responseData is List) {
        moviesData = responseData;
      } 
      // Basit map formatı: {"movies": [...]}
      else if (responseData is Map) {
        final possibleKeys = ['movies', 'favorites', 'data', 'items', 'results'];
        bool found = false;
        
        for (final key in possibleKeys) {
          if (responseData.containsKey(key) && responseData[key] is List) {
            moviesData = responseData[key] as List;
            found = true;
            break;
          }
        }
        
        if (!found) {
          throw Exception('Desteklenen liste anahtarı bulunamadı. Mevcut anahtarlar: ${responseData.keys}');
        }
      }
      else {
        throw Exception('Bilinmeyen yanıt formatı: ${responseData.runtimeType}');
      }

      // Film listesini oluştur (hata toleranslı)
      final movies = <MovieModel>[];
      
      for (var item in moviesData) {
        try {
          if (item is Map<String, dynamic>) {
            movies.add(MovieModel.fromJson(item));
          } 
          else if (item is Map) {
            movies.add(MovieModel.fromJson(Map<String, dynamic>.from(item)));
          }
          else if (item is String) {
            // Sadece ID geliyorsa (nadir durum)
            movies.add(MovieModel(
              id: item,
              title: "Film ID: $item",
              description: "Film detayları yüklenemedi",
              posterUrl: "",
              isFavorite: true,
            ));
          }
          else {
            print('Geçersiz film veri tipi atlandı: ${item.runtimeType} - $item');
          }
        } catch (e) {
          print('Film dönüştürme hatası atlandı: $e\nVeri: $item');
          // Hatalı veriyi atla, devam et
        }
      }

      print('Başarıyla dönüştürülen favori film sayısı: ${movies.length}');

      return MovieListResponseModel(
        movies: movies,
        totalPages: 1,
        currentPage: 1,
      );
    } on DioException catch (dioError) {
      final errorMessage = dioError.response?.data?['message'] ?? dioError.message;
      throw Exception('Favori filmler API hatası: $errorMessage');
    } catch (e) {
      throw Exception('Favoriler alınırken hata: $e');
    }
  }
}