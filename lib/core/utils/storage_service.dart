
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shartflix/data/services/log_service.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
static Future<void> saveToken(String token) async {
  if (token.isEmpty) {
    LogService.w('BOŞ TOKEN KAYDEDİLMEYE ÇALIŞILDI!');
    throw Exception('Geçersiz token');
  }
  
  await _storage.write(key: 'auth_token', value: token);
  LogService.i('🔐 TOKEN KAYDEDİLDİ: $token');
}
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}