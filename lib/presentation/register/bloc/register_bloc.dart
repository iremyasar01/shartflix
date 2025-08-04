import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/enums/form_status.dart';
import 'package:shartflix/data/services/auth_service.dart';
import 'package:shartflix/core/utils/storage_service.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _authService;

  RegisterBloc({required AuthService authService})
      : _authService = authService,
        super(const RegisterState()) {
    // Event'leri ilgili fonksiyonlara bağlıyoruz
    on<RegisterNameChanged>((e, emit) => emit(state.copyWith(name: e.name)));
    on<RegisterEmailChanged>((e, emit) => emit(state.copyWith(email: e.email)));
    on<RegisterPasswordChanged>(
        (e, emit) => emit(state.copyWith(password: e.password)));
    on<RegisterConfirmPasswordChanged>(
        (e, emit) => emit(state.copyWith(confirmPassword: e.confirmPassword)));
    on<RegisterAgreementChanged>(
        (e, emit) => emit(state.copyWith(isAgreed: e.isAgreed)));
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormStatus.loading, errorMessage: null));

    try {
      final token = await _authService.register(
        state.name,
        state.email,
        state.password,
      );
      // TOKEN KONTROLÜ
      if (token.isEmpty) {
        throw Exception('Token alınamadı');
      }
      await StorageService().saveToken(token);

      // BAŞARILI DURUMDA FORM VERİLERİNİ SIFIRLA
      emit(RegisterState.initial().copyWith(status: FormStatus.success));
    } catch (e) {
      // HATA MESAJINI DÜZENLE
      final cleanError = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: FormStatus.failure,
        errorMessage: cleanError,
      ));
    }
  }
}
