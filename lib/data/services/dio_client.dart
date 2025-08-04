import 'package:dio/dio.dart';
import 'package:shartflix/core/utils/storage_service.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://caseapi.servicelabs.tech',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // Singleton pattern ile her zaman aynı Dio nesnesini kullan
  DioClient._();
  static Dio get instance => _dio;

  static void initialize() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Her istekten önce burası çalışır.
          
          // Saklanmış token'ı al
          final token = await StorageService().getToken();

          if (token != null) {
            // Eğer token varsa, Authorization başlığına ekle
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // İsteğin devam etmesini sağla
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Her başarılı yanıttan sonra burası çalışır.
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Her hatadan sonra burası çalışır.
          return handler.next(e);
        },
      ),
    );
  }
}
