import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/domain/repositories/profile_repository.dart';
import 'package:shartflix/presentation/profile/bloc/profile_bloc.dart';
import 'package:shartflix/presentation/profile/widgets/profile_header.dart';
import 'package:shartflix/presentation/profile/widgets/profile_info_section.dart';
import 'package:shartflix/presentation/profile/widgets/account_actions_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        repository: context.read<ProfileRepository>(),
      )..add(LoadProfileEvent()),
      child: Scaffold(
        //appBar: AppBar(
          //title: const Text('Profil'),
          //automaticallyImplyLeading: false,
        //),
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
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileHeader(user: state.user),
                    const SizedBox(height: 24),
                    ProfileInfoSection(user: state.user),
                    const SizedBox(height: 24),
                    AccountActionsSection(user: state.user),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        // CUSTOM BOTTOM NAVBAR GERİ EKLENDİ
       // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }
}