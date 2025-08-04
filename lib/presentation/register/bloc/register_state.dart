import 'package:equatable/equatable.dart';
import 'package:shartflix/core/enums/form_status.dart';

class RegisterState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isAgreed;
  final FormStatus status;
  final String? errorMessage;

  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isAgreed = false,
    this.status = FormStatus.initial,
    this.errorMessage,
  });
  factory RegisterState.initial() => const RegisterState();
  // Şifrelerin eşleşip eşleşmediğini kontrol eder.
  bool get passwordsMatch => password == confirmPassword;

  // Formun geçerli olup olmadığını kontrol eder.
  // Tüm alanlar dolu, şifre en az 6 karakter, şifreler eşleşiyor ve sözleşme kabul edilmiş olmalı.
  bool get isValid =>
      name.isNotEmpty &&
      email.contains('@') && 
      password.length >= 6 &&
      passwordsMatch &&
      isAgreed;

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isAgreed,
    FormStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isAgreed: isAgreed ?? this.isAgreed,
      status: status ?? this.status,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        confirmPassword,
        isAgreed,
        status,
        errorMessage,
      ];
}
