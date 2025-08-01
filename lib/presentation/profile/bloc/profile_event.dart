part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfilePhotoEvent extends ProfileEvent {
  final File imageFile;

  const UpdateProfilePhotoEvent(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}