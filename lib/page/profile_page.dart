import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/profile/profile_bloc.dart';
import '../component/custom_card.dart';
import '../component/my_friends_my_posts_menu.dart';
import '../component/profile_banner.dart';
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
        if (context.read<AuthBloc>().state.status == AuthStatus.authenticated) {
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
    final String? bannerUrl =
        context.read<ProfileBloc>().state.profile?.banner?.url;
    return SizedBox(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 210,
            child: bannerUrl != null
                ? CachedNetworkImage(
                    imageUrl: bannerUrl,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image.asset('assets/images/louvre.png'),
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
    int? friendsCount = context.read<ProfileBloc>().state.friends?.meta.total;
    friendsCount ??= 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(friendsCount.toString()),
          const Text('amis ajoutés'),
        ],
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
