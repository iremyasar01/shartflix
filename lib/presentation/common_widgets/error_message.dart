import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? message;

  const ErrorMessage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    // Eğer gösterilecek bir mesaj varsa, onu stilize edilmiş bir
    // Text widget'ı içinde göster.
    if (message != null && message!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          message!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red.shade300,
            fontSize: 14,
          ),
        ),
      );
    }

    // Gösterilecek bir mesaj yoksa, yer kaplamayan boş bir widget döndür.
    return const SizedBox.shrink();
  }
}
