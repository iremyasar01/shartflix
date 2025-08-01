class UserEntity {
  final String? id;
  final String name;
  final String email;
  final String? photoUrl;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}