import 'package:shartflix/domain/entities/user_entity.dart';

/// API'den gelen JSON verisini doğrudan temsil eden model.
class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl, // UserEntity'de bu nullable olmalı
  });

  /// Gelen JSON'ı UserModel nesnesine dönüştüren güvenli factory metodu.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // ?? operatörü: Eğer soldaki değer null ise, sağdakini kullan.
      id: json['id'] ?? '', // id null gelirse boş string ata
      name: json['name'] ?? 'İsim Yok', // name null gelirse 'İsim Yok' yaz
      email: json['email'] ?? 'E-posta Yok', // email null gelirse 'E-posta Yok' yaz
      photoUrl: json['photoUrl'], // photoUrl zaten null olabilir
    );
  }
}