import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/presentation/login/bloc/login_bloc.dart';


class PasswordInputField extends StatelessWidget {
  final bool isObscured;
  final VoidCallback onVisibilityToggle;

  const PasswordInputField({
    super.key,
    required this.isObscured,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: isObscured,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade800.withOpacity(0.5),
            hintText: 'Şifre',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey.shade400,
              ),
              onPressed: onVisibilityToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}