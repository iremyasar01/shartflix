import 'package:flutter/material.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Zaten bir hesabın var mı?',
            style: TextStyle(color: Colors.white70)),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text('Giriş Yap!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
