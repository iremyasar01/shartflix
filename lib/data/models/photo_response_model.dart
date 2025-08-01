class PhotoResponseModel {
  final String photoUrl;

  PhotoResponseModel({required this.photoUrl});

  factory PhotoResponseModel.fromJson(Map<String, dynamic> json) {
    return PhotoResponseModel(
      photoUrl: json['photoUrl'] as String,
    );
  }
}