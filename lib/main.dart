import 'package:flutter/material.dart';
import 'package:shartflix/data/services/dio_client.dart';
import 'package:shartflix/presentation/home/home_screen.dart';
import 'package:shartflix/presentation/login/screens/login_screen.dart';
import 'package:shartflix/presentation/register/screens/register_screen.dart';
import 'package:shartflix/presentation/splash/splash_screen.dart';

void main() async {
  // Flutter uygulamasının başlamadan önce bazı işlemlerin yapılabilmesi için gereklidir.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Her API isteğine token ekleyecek olan Dio Interceptor'ını başlat.
   DioClient.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shartflix',
      // Uygulama genelinde koyu bir tema kullanalım.
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),
      // Uygulama, oturum kontrolünü yapacak olan SplashScreen ile başlar.
      home: const SplashScreen(), 
      // Sayfalar arası geçiş için kullanılacak rotaları tanımla.
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
