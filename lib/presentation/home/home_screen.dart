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
  // --- MEVCUT KODUN OLDUĞU GİBİ KALIYOR ---
  String? _userToken;

  // Navigasyon barı için seçili olan sekmeyi tutan değişken
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
  // --- MEVCUT KODUN SONU ---

  // Navigasyon barındaki bir öğeye tıklandığında bu fonksiyon çalışır
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- YENİ YAPI ---
    // Sayfaları bir listede tutuyoruz.
    final List<Widget> pages = [
      // Sayfa 0: Senin orijinal 'body' içeriğin
      _buildHomePageBody(), 
      // Sayfa 1: Mevcut ProfileScreen'in
      const ProfileScreen(), 
    ];

    return Scaffold(
      appBar: AppBar(
        // Seçili sekmeye göre başlığı dinamik olarak değiştiriyoruz
        title: Text(_selectedIndex == 0 ? 'Ana Sayfa' : 'Profil'),
        // Sadece ana sayfadayken çıkış yapma butonu görünsün
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ]
            : null,
        automaticallyImplyLeading: false,
      ),
      // IndexedStack, sekmeler arasında geçiş yaparken sayfaların durumunu korur.
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      // --- YENİ EKLENEN BOTTOM NAVIGATION BAR ---
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

  // --- MEVCUT 'body' KODUNU BİR FONKSİYONA TAŞIDIK ---
  // Hiçbir satırını silmedim, sadece daha düzenli olması için ayırdım.
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
          // Bu butonu artık kullanmadığımız için kaldırdım, çünkü profil
          // sayfasına gitme işini artık BottomNavigationBar yapıyor.
          // İstersen geri ekleyebiliriz.
        ],
      ),
    );
  }
}