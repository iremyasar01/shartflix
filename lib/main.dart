import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/data/services/dio_client.dart';
import 'package:shartflix/domain/repositories/profile_repository.dart';
import 'package:shartflix/injection_container.dart' as di;
import 'package:shartflix/presentation/auth/auth_wrapper.dart';
import 'package:shartflix/presentation/home/home_screen.dart';
import 'package:shartflix/presentation/login/screens/login_screen.dart';
import 'package:shartflix/presentation/profile/screens/profile_screen.dart';
import 'package:shartflix/presentation/register/screens/register_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioClient.initialize();
  di.init(); // Dependency Injection başlatılıyor
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => di.sl<ProfileRepository>()),
      ],
      child: MaterialApp(
        title: 'Shartflix',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF101010),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.dark,
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}