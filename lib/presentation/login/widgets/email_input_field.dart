import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/presentation/login/bloc/login_bloc.dart';


class EmailInputField extends StatelessWidget {
  const EmailInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginBloc>().add(LoginEmailChanged(email)),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade800.withOpacity(0.5),
            hintText: 'E-Posta',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.mail_outline, color: Colors.grey.shade400),
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