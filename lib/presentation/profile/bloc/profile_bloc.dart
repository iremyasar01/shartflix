import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/domain/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitialState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfilePhotoEvent>(_onUpdateProfilePhoto);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final user = await repository.getUserProfile();
      emit(ProfileLoadedState(user: user));
    } catch (e) {
      emit(ProfileErrorState(message: 'Profil yüklenemedi: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfilePhoto(
    UpdateProfilePhotoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is ProfileLoadedState) {
        final currentState = state as ProfileLoadedState;
        emit(ProfileLoadingState());
        
        final newPhotoUrl = await repository.updateProfilePhoto(event.imageFile);
        
        if (newPhotoUrl.isEmpty) {
          throw Exception('Sunucu geçersiz URL döndürdü');
        }
        
        final updatedUser = currentState.user.copyWith(
          photoUrl: newPhotoUrl,
        );
        
        emit(ProfileLoadedState(user: updatedUser));
      }
    } catch (e) {
      emit(ProfileErrorState(message: 'Fotoğraf güncellenemedi: ${e.toString()}'));
      
      // Önceki state'e dön
      if (state is ProfileLoadedState) {
        final prevState = state as ProfileLoadedState;
        emit(ProfileLoadedState(user: prevState.user));
      } else {
        add(LoadProfileEvent());
      }
    }
  }
}