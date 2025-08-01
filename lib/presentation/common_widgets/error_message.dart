import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? message;

  const ErrorMessage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message != null && message!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message!,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}