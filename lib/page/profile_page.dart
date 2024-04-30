import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/profile/profile_bloc.dart';
import '../component/custom_card.dart';
import '../component/form/login_form.dart';
import '../component/my_friends_my_posts_menu.dart';
import '../component/profile_banner.dart';
import '../constants/route_name.dart';
import '../repository/profile_repository.dart';
import '../service/profile_remote_data_source.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (context.read<AuthBloc>().state.status ==
            AuthStatus.authenticated) {
          return _buildProfilePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  RepositoryProvider<ProfileRepository> _buildProfilePage() {
    return RepositoryProvider<ProfileRepository>(
    create: (context) => ProfileRepository(
      profileRemoteDataSource: ProfileRemoteDataSource(),
      // TODO(nono): Implement ProfileLocalDataSource
      //profilelocalDataSource: ProfileLocalDataSource(),
    ),
    child: BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        profileService: ProfileService(),
      )..add(GetProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(GetProfileEvent());
              },
              child: ListView(
                children: [
                  Column(
                    children: [
                      _buildProfileInfos(context),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildSubsAndVisitedPlaces(context),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      children: [
                        const MyFriendsMyPostsMenu(),
                        const SizedBox(
                          height: 15,
                        ),
                        navigationShell,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
  }

  SizedBox _buildProfileInfos(BuildContext context) {
    return SizedBox(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            child: Image.asset('assets/images/louvre.png'),
          ),
          const Positioned(bottom: 0, child: ProfileBanner()),
        ],
      ),
    );
  }

  Center _buildSubsAndVisitedPlaces(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCard(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 80,
            content: _buildFriendsCard(context),
          ),
          const SizedBox(
            width: 20,
          ),
          CustomCard(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 80,
            content: _buildVisitedBuildingCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsCard(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('NB ABONNES'), Text('amis ajoutés')],
      ),
    );
  }

  Widget _buildVisitedBuildingCard(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('NB VISITED'), Text('monuments visités')],
      ),
    );
  }
}
