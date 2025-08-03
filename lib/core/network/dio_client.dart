// core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:shartflix/core/utils/storage_service.dart';

class DioClient {
  final Dio dio;
  final StorageService storage;

  DioClient({required this.storage})
      : dio = Dio(BaseOptions(
          baseUrl: 'https://caseapi.servicelabs.tech',
          connectTimeout: const Duration(seconds: 30),
        )) {
    // Token interceptor ekleme
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token yenileme işlemleri
        }
        return handler.next(error);
      },
    ));
  }
}