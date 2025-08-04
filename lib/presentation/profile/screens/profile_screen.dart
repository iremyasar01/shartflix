import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/domain/repositories/profile_repository.dart';
import 'package:shartflix/presentation/profile/bloc/profile_bloc.dart';
import 'package:shartflix/presentation/profile/widgets/profile_content_view.dart';

class ProfileScreen extends StatelessWidget {
  final String? token;

  const ProfileScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        repository: context.read<ProfileRepository>(),
      )..add(LoadProfileEvent()),
      child: Scaffold(
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoadedState) {
              // Veri yüklendiğinde, tüm görsel yükü ProfileContentView üstlenir.
              return ProfileContentView(user: state.user);
            }
            // Diğer tüm durumlarda (yükleniyor, hata, başlangıç)
            // bir yüklenme animasyonu göster.
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          },
        ),
      ),
    );
  }
}
