import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/enums/form_status.dart';
import 'package:shartflix/presentation/common_widgets/custom_text_field.dart';
import 'package:shartflix/presentation/common_widgets/error_message.dart';
import 'package:shartflix/presentation/common_widgets/social_button.dart';
import 'package:shartflix/presentation/register/bloc/register_bloc.dart';
import 'package:shartflix/presentation/register/bloc/register_event.dart';
import 'package:shartflix/presentation/register/bloc/register_state.dart';

// Yeni oluşturulan ve ayrılan widget'ları import ediyoruz
import '../widgets/agreement_checkbox.dart';
import '../widgets/login_link.dart';
import '../widgets/register_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    // --- EN ÖNEMLİ GÜNCELLEME BURADA ---
    // BlocListener, UI'ı yeniden çizmeden arka planda işlem yapmak için kullanılır.
    // (Snackbar gösterme, yönlendirme yapma gibi)
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        // Başarı durumunu dinle
        if (state.status == FormStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz...'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
            // 2 saniye sonra giriş sayfasına yönlendir
          Future.delayed(const Duration(seconds: 2), () {
           
            Navigator.of(context).pushReplacementNamed('/login');
          });
        }

        // Hata durumunu dinle (opsiyonel, hata mesajı zaten ErrorMessage widget'ında gösteriliyor
        // ama burada da bir snackbar gösterebiliriz)
        if (state.status == FormStatus.failure && state.errorMessage != null) {
          // Hata mesajını göster
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              const Text(
                'Hoşgeldiniz',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tempus varius a vitae interdum id tortor\nelementum tristique eleifend at.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),

              // --- Form Alanları ---
              CustomTextField(
                hintText: 'Ad Soyad',
                prefixIcon: Icons.person_outline,
                onChanged: (value) => context.read<RegisterBloc>().add(RegisterNameChanged(value)),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'E-Posta',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => context.read<RegisterBloc>().add(RegisterEmailChanged(value)),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Şifre',
                prefixIcon: Icons.lock_outline,
                isObscured: _isPasswordObscured,
                onVisibilityToggle: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                onChanged: (value) => context.read<RegisterBloc>().add(RegisterPasswordChanged(value)),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Şifre Tekrar',
                prefixIcon: Icons.lock_outline,
                isObscured: _isConfirmPasswordObscured,
                onVisibilityToggle: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                onChanged: (value) => context.read<RegisterBloc>().add(RegisterConfirmPasswordChanged(value)),
                // Hata metnini doğrudan TextField içinde göstermek için
                errorTextSelector: (RegisterState state) =>
                    state.password.isNotEmpty && state.confirmPassword.isNotEmpty && !state.passwordsMatch
                        ? 'Şifreler eşleşmiyor'
                        : null,
              ),
              const SizedBox(height: 20),
              const AgreementCheckbox(),
              const SizedBox(height: 20),
              const RegisterButton(),
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
              const SizedBox(height: 30),
              const LoginLink(),
              
              // Hata mesajını göstermek için widget'ı buraya ekliyoruz.
              // SnackBar kullandığımız için bu widget'a artık gerek kalmayabilir,
              // tercih size kalmış. İkisini bir arada da kullanabilirsiniz.
               const ErrorMessage(), 
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}