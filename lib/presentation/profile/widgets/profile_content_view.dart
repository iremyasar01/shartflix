import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/presentation/profile/bloc/profile_bloc.dart';

/// Profil sayfasının görsel içeriğini yöneten widget.
class ProfileContentView extends StatelessWidget {
  final UserEntity user;
  final bool isUploading;

  const ProfileContentView({
    super.key,
    required this.user,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _getProfileImage(user.photoUrl),
                  backgroundColor: Colors.grey.shade800,
                ),
                // Fotoğraf yüklenirken bir yüklenme animasyonu göster
                if (isUploading)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                // Yükleme yoksa, kamera butonunu göster
                if (!isUploading)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: Colors.red,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => _pickAndUploadImage(context),
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400),
          ),
          // Diğer profil bilgileri ve butonlar buraya eklenebilir.
        ],
      ),
    );
  }

  /// Profil fotoğrafını almak için yardımcı fonksiyon.
  ImageProvider _getProfileImage(String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CachedNetworkImageProvider(photoUrl);
    }
    // Varsayılan avatar için projenizde bir resim olduğundan emin olun.
    return const AssetImage('assets/images/default_avatar.png');
  }

  /// Fotoğraf seçme, sıkıştırma ve yükleme işlemini yöneten fonksiyon.
  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile == null) return; // Kullanıcı seçim yapmadıysa işlemi iptal et

    try {
      final file = File(pickedFile.path);
      final targetPath = '${file.parent.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Seçilen dosyayı sıkıştır
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 88,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (compressedFile == null) {
        throw Exception('Fotoğraf sıkıştırılamadı.');
      }

      // Widget'ın hala ekranda olduğundan emin ol
      if (context.mounted) {
        // Sıkıştırılmış dosyayı BLoC'a gönder
        context.read<ProfileBloc>().add(UpdateProfilePhotoEvent(File(compressedFile.path)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fotoğraf işlenemedi: $e')),
        );
      }
    }
  }
}