import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/enums/form_status.dart';
import 'package:shartflix/presentation/register/bloc/register_bloc.dart';
import 'package:shartflix/presentation/register/bloc/register_event.dart';
import 'package:shartflix/presentation/register/bloc/register_state.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      // Sadece butonun durumunu etkileyen değişikliklerde yeniden çizim yap
      buildWhen: (previous, current) => previous.status != current.status || previous.isValid != current.isValid,
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            disabledBackgroundColor: Colors.red.shade900.withOpacity(0.5),
          ),
          onPressed: state.isValid && state.status != FormStatus.loading
              ? () => context.read<RegisterBloc>().add(const RegisterSubmitted())
              : null,
          child: state.status == FormStatus.loading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text(
                  'Şimdi Kaydol',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
        );
      },
    );
  }
}
