import 'dart:io';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/data/services/profile_service.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService profileService;

  ProfileRepositoryImpl({required this.profileService});

  @override
  Future<UserEntity> getUserProfile() async {
    return await profileService.getUserProfile();
  }

  @override
  Future<String> updateProfilePhoto(File imageFile) async {
    final token = await StorageService.getToken();
    
    if (token == null) {
      throw Exception('Kullanıcı oturumu bulunamadı. Lütfen tekrar giriş yapın.');
    }

    final responseModel = await profileService.uploadProfilePhoto(
      token: token,
      imageFile: imageFile,
    );
    
    // NULL KONTROLÜ EKLEDİM
    if (responseModel == null || responseModel.photoUrl.isEmpty) {
      throw Exception('Sunucu geçersiz bir fotoğraf URLsi döndürdü.');
    }
    
    return responseModel.photoUrl;
  }
}