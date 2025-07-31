import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/enums/form_status.dart';
import 'package:shartflix/presentation/common_widgets/error_message.dart';
import 'package:shartflix/presentation/common_widgets/social_button.dart';
import 'package:shartflix/presentation/login/bloc/login_bloc.dart';



import '../widgets/email_input_field.dart';
import '../widgets/login_button.dart';
import '../widgets/password_input_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Giriş Başarılı!')),
            );
          // Splash screen'den gelen yönlendirme mantığına uygun olarak
          // pushReplacementNamed kullanmak daha doğrudur.
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              const Text(
                'Merhabalar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tempus varius a vitae interdum id\n'
                'tortor elementum tristique eleifend at.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 40),

              // --- AYRILMIŞ WIDGET'LAR ---
              const EmailInputField(),
              const SizedBox(height: 16),
              PasswordInputField(
                isObscured: _isPasswordObscured,
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Şifremi unuttum sayfasına yönlendir.
                  },
                  child: const Text(
                    'Şifremi unuttum',
                    style: TextStyle(color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const LoginButton(),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(icon: Icons.g_mobiledata),
                  SizedBox(width: 20),
                  SocialButton(icon: Icons.apple),
                  SizedBox(width: 20),
                  SocialButton(icon: Icons.facebook),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bir hesabın yok mu?', style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () {
                      // Rota kullanarak gitmek daha temiz bir yöntemdir.
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text('Kayıt Ol!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const ErrorMessage(), // Hata mesajı widget'ı da ayrıldı.
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}