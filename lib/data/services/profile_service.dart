import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shartflix/data/models/photo_response_model.dart';
import 'package:shartflix/data/models/user_model.dart';
import 'package:shartflix/data/services/dio_client.dart';

class ProfileService {
  final Dio _dio = DioClient.instance;

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profile');

      // API'den gelen yanıtın içindeki 'data' objesini alıyoruz.
      // Eğer 'data' objesi yoksa veya Map değilse, hata fırlat.
      if (response.data != null && response.data['data'] is Map<String, dynamic>) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Profil verisi beklenen formatta değil.');
      }
    } on DioException catch (e) {
      // Hata durumunda daha anlamlı bir mesaj ver
      throw Exception('Profil bilgileri alınamadı: ${e.message}');
    }
  }

   Future<PhotoResponseModel?> uploadProfilePhoto({
    required String token,
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await _dio.post(
        '/user/upload_photo',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // YANIT FORMATI KONTROLÜ
      if (response.data is Map<String, dynamic> && 
          response.data['photoUrl'] is String) {
        return PhotoResponseModel(photoUrl: response.data['photoUrl']);
      }

      return null;
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 
                          e.message ?? 
                          'Fotoğraf yüklenirken bilinmeyen hata';
      throw Exception(errorMessage);
    }
  }
}