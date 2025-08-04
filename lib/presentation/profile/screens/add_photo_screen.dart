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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white12,
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Profil Detayı',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Fotoğraflarınızı Yükleyin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Resources out incentivize\nrelaxation floor loss cc.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildImageBox(),
                const SizedBox(height: 32),
                if (_errorMessage != null)
                  ErrorMessage(message: _errorMessage!),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _onContinuePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Devam Et',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox() {
    return GestureDetector(
      onTap: _isUploading ? null : () => _pickImage(ImageSource.gallery),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : widget.user.photoUrl != null && widget.user.photoUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        Image.network(widget.user.photoUrl!, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Icon(Icons.add, color: Colors.white54, size: 40),
                  ),
      ),
    );
  }

  void _onContinuePressed() {
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
}
