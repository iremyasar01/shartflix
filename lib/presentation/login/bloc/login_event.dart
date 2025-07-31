part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// E-posta alanı değiştiğinde tetiklenir.
class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// Şifre alanı değiştiğinde tetiklenir.
class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

/// Giriş yap butonuna basıldığında tetiklenir.
class LoginSubmitted extends LoginEvent {}