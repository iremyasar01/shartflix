import 'package:flutter/material.dart';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/presentation/login/screens/login_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await StorageService.getToken();
    setState(() {
      _userToken = token;
    });
  }

  Future<void> _logout() async {
    await StorageService.deleteToken();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hoşgeldiniz!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            if (_userToken != null)
              Text(
                'Token: ${_userToken!.substring(0, 15)}...', // Token'ın sadece ilk 15 karakteri
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Diğer sayfalara yönlendirme örneği
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Profil Sayfasına Git'),
            ),
          ],
        ),
      ),
    );
  }
}