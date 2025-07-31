import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/data/services/auth_service.dart';
import 'package:shartflix/presentation/register/bloc/register_bloc.dart';
import 'package:shartflix/presentation/register/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: BlocProvider(
        create: (context) => RegisterBloc(authService: AuthService()),
        child: const RegisterForm(),
      ),
    );
  }
}
