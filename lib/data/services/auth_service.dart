import 'package:dio/dio.dart';
import 'package:shartflix/data/services/log_service.dart';
import 'dio_client.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  Future<String> login(String email, String password) async {
   
    try {
      final response = await _dio.post(
        '/user/login',
        data: {'email': email, 'password': password},
      );

      // Gelen yanıtı analiz et
      final responseData = response.data;
      if (responseData == null || responseData is! Map) {
        throw Exception('Geçersiz yanıt formatı');
      }

      // --- DEĞİŞİKLİK BURADA: 'data' kutusunun içine bakıyoruz ---
      final String? token = responseData['data']?['token']?.toString();

      if (token == null || token.isEmpty) {
        LogService.d(' TOKEN BULUNAMADI! Yanıt: $responseData');
        throw Exception('Giriş başarılı ama token alınamadı');
      }

      LogService.i('🔑 LOGIN BAŞARILI - TOKEN: $token');
      return token;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message']?.toString() ?? 'Giriş başarısız.';
      throw Exception(errorMessage);
    }
  }

  Future<String> register(String name, String email, String password) async {
    LogService.d('--- REGISTER FONKSİYONU ÇAĞIRILDI ---');
    try {
      final response = await _dio.post(
        '/user/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      // Gelen yanıtı analiz et
      final responseData = response.data;
      if (responseData == null || responseData is! Map) {
        throw Exception('Geçersiz yanıt formatı');
      }

      final String? token = responseData['data']?['token']?.toString();

      if (token == null || token.isEmpty) {
        LogService.w('TOKEN BULUNAMADI! Yanıt: $responseData');
        throw Exception('Kayıt başarılı ama token alınamadı');
      }

      LogService.i(' KAYIT BAŞARILI - TOKEN ALINDI: $token');
      return token;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message']?.toString() ?? 'Kayıt başarısız.';
      throw Exception(errorMessage);
    }
  }
}
