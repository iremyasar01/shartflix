import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/presentation/common_widgets/error_message.dart';
import 'package:shartflix/presentation/profile/bloc/profile_bloc.dart';


class AddPhotoScreen extends StatefulWidget {
  final UserEntity user;

  const AddPhotoScreen({super.key, required this.user});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  File? _selectedImage;
  String? _errorMessage;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Fotoğrafı'),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadedState) {
            Navigator.pop(context);
          } else if (state is ProfileErrorState) {
            setState(() {
              _errorMessage = state.message;
              _isUploading = false;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_errorMessage != null)
                ErrorMessage(message: _errorMessage!),
              
              const SizedBox(height: 24),
              
              _buildImagePreview(),
              
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPhotoOptionButton(
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  _buildPhotoOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              if (_selectedImage != null)
                _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _selectedImage != null
          ? Image.file(_selectedImage!, fit: BoxFit.cover)
          : widget.user.photoUrl != null && widget.user.photoUrl!.isNotEmpty
              ? Image.network(widget.user.photoUrl!, fit: BoxFit.cover)
              : const Center(
                  child: Icon(Icons.person, size: 60, color: Colors.grey),
                ),
    );
  }

  Widget _buildPhotoOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: _isUploading ? null : onPressed,
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isUploading ? null : _uploadPhoto,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          child: _isUploading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Fotoğrafı Yükle'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _isUploading ? null : () => setState(() {
            _selectedImage = null;
            _errorMessage = null;
          }),
          child: const Text('Seçimi İptal Et'),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Dosya boyutu kontrolü (max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          setState(() {
            _errorMessage = 'Fotoğraf boyutu çok büyük (max 5MB)';
            _selectedImage = null;
          });
          return;
        }

        setState(() {
          _selectedImage = file;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fotoğraf seçilemedi: ${e.toString()}';
      });
    }
  }

  void _uploadPhoto() {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = 'Lütfen bir fotoğraf seçin';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    context.read<ProfileBloc>().add(
          UpdateProfilePhotoEvent(_selectedImage!),
        );
  }
}