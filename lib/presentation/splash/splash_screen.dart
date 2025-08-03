import 'package:flutter/material.dart';
import 'package:shartflix/core/utils/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Bütün asenkron (beklemeli) işlemleri önce yapalım.
    // 1. Splash ekranının biraz görünür kalmasını sağla.
    // 2. Token'ı güvenli depodan oku.
    // Future.wait, her iki işlemin de aynı anda bitmesini bekler.
    final results = await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      StorageService().getToken(),
    ]);

    // Sonuçlardan token'ı alalım (ikinci işlemin sonucuydu).
    final String? token = results[1] as String?;

    // --- EN GÜVENLİ YÖNTEM ---
    // Bütün beklemeler bittikten sonra, context'i kullanmadan HEMEN ÖNCE
    // widget'ın hala ekranda olup olmadığını kontrol et.
    if (mounted) {
      if (token != null) {
        // Token varsa, ana ekrana yönlendir.
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Token yoksa, giriş ekranına yönlendir.
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Resminizin çalıştığından emin olmak için assets klasörünüzü kontrol edin.
            Image.asset('assets/images/SinFlixSplash.png', width: 200),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              color: Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
