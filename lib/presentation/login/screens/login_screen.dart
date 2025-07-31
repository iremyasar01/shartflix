import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/data/services/auth_service.dart';
import 'package:shartflix/presentation/login/bloc/login_bloc.dart';
import 'package:shartflix/presentation/login/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan rengini tasarıma uygun olarak ayarlıyoruz.
      backgroundColor: const Color(0xFF101010),
      body: BlocProvider(
        create: (context) => LoginBloc(
          authService: AuthService(),
          // storageService: StorageService(), // Token saklama servisini de burada provide edin.
        ),
        child: const LoginForm(),
      ),
    );
  }
}
