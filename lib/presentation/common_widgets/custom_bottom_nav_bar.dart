import 'package:flutter/material.dart';

/// Uygulamanın ana sekmeleri arasında gezinmeyi sağlayan,
/// yeniden kullanılabilir alt navigasyon barı.
class CustomBottomNavBar extends StatelessWidget {
  /// Hangi sekmenin aktif olduğunu belirtir (0: Anasayfa, 1: Profil vb.).
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: currentIndex,
      onTap: (int index) {
        // Eğer kullanıcı zaten bulunduğu sekmenin ikonuna tıklarsa,
        // gereksiz bir yönlendirme yapma.
        if (index == currentIndex) return;

        // Tıklanan sekmeye göre ilgili sayfaya yönlendir.
        // pushReplacementNamed kullanmak, sayfalar arasında sonsuz bir
        // yığın oluşmasını engeller, daha performanslıdır.
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      // Stil Ayarları
      selectedItemColor: Colors.red.shade400,
      unselectedItemColor: Colors.grey.shade500,
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      type: BottomNavigationBarType.fixed, // 2'den fazla öğe olsa bile stilini korur
      showSelectedLabels: true,
      showUnselectedLabels: false,
    );
  }
}
