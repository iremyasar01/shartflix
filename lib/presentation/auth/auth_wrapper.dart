import 'package:flutter/material.dart';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/presentation/home/home_screen.dart';
import 'package:shartflix/presentation/login/screens/login_screen.dart'; // Ana sayfan


class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Hafızadan token'ı oku
    final token = await StorageService.getToken();

    // Bu widget'ın hala "ağaçta" olup olmadığını kontrol et (önemli!)
    if (!mounted) return;

    if (token != null) {
      // Token varsa: Ana sayfaya yönlendir
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Token yoksa: Giriş ekranına yönlendir
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kontrol yapılırken bir yüklenme animasyonu göster
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}