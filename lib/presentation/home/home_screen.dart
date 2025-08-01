import 'package:flutter/material.dart';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/presentation/login/screens/login_screen.dart';
import 'package:shartflix/presentation/profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userToken;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await StorageService.getToken();
    if (mounted) {
      setState(() {
        _userToken = token;
      });
    }
  }

  Future<void> _logout() async {
    await StorageService.deleteToken();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePageBody(),
      const ProfileScreen(), 
    ];

    return Scaffold(
      // SADECE ANA SAYFADA (index 0) APP BAR GÖSTER
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text('Ana Sayfa'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
              automaticallyImplyLeading: false,
            )
          : null, // Profil sayfasında AppBar olmayacak
      
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red.shade400,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      ),
    );
  }

  Widget _buildHomePageBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Hoşgeldiniz!', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          if (_userToken != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SelectableText(
                'Token: $_userToken',
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}