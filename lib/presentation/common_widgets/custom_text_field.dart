import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/presentation/register/bloc/register_bloc.dart';
import 'package:shartflix/presentation/register/bloc/register_state.dart';

// Bu widget'ı daha genel hale getirmek için Bloc'a olan bağımlılığı
// kaldırıp, parametre olarak errorText alması daha doğru olur.
// Ama şimdilik BLoC ile olan bağlantıyı göstermek için bu şekilde bırakıyorum.

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  
  // Şifre alanı için opsiyonel parametreler
  final bool isObscured;
  final VoidCallback? onVisibilityToggle;
  final String? Function(RegisterState)? errorTextSelector;


  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    this.keyboardType,
    this.isObscured = false,
    this.onVisibilityToggle,
    this.errorTextSelector,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: isObscured,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration(
            hintText,
            prefixIcon,
            errorText: errorTextSelector?.call(state),
            suffixIcon: onVisibilityToggle != null 
              ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          ),
        );
      },
    );
  }
}

// Bu stil fonksiyonu da bu dosyanın içinde private kalabilir.
InputDecoration _inputDecoration(String hintText, IconData prefixIcon,
    {Widget? suffixIcon, String? errorText}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade800.withOpacity(0.5),
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    prefixIcon: Icon(prefixIcon, color: Colors.grey.shade400),
    suffixIcon: suffixIcon,
    errorText: errorText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade300, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
    ),
  );
}
