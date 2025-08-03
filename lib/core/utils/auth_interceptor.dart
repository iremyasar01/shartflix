import 'package:dio/dio.dart';
import 'package:shartflix/core/utils/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService storageService;

  AuthInterceptor(this.storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Token'ı storage'dan al
    final token = await storageService.getToken();
    
    // Token varsa header'a ekle
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }
}