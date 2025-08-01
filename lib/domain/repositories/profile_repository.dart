import 'dart:io';

import 'package:shartflix/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getUserProfile();
  Future<String> updateProfilePhoto(File imageFile);
}