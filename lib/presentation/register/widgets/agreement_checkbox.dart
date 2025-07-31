import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/presentation/register/bloc/register_bloc.dart';
import 'package:shartflix/presentation/register/bloc/register_event.dart';
import 'package:shartflix/presentation/register/bloc/register_state.dart';

class AgreementCheckbox extends StatelessWidget {
  const AgreementCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.isAgreed != current.isAgreed,
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: state.isAgreed,
                onChanged: (value) =>
                    context.read<RegisterBloc>().add(RegisterAgreementChanged(value ?? false)),
                checkColor: Colors.black,
                activeColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Kullanıcı sözleşmesini '),
                    TextSpan(
                      text: 'okudum ve kabul ediyorum.',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                        
                          print('Kullanıcı sözleşmesi tıklandı.');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}