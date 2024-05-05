import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/notifier_bloc/notification_type.dart';
import '../bloc/notifier_bloc/notifier_bloc.dart';
import '../bloc/notifier_bloc/notifier_event.dart';
import '../bloc/profile/profile_bloc.dart';
import '../component/banner_picture.dart';
import '../component/custom_card.dart';
import '../component/my_friends_my_posts.dart';
import '../component/profile_banner.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../repository/profile_repository.dart';
import '../service/profile_remote_data_source.dart';
import 'login_page.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  @override
  Widget build(BuildContext context) {
    return _buildMyProfilePage();
  }

  BlocBuilder<AuthBloc, AuthState> _buildMyProfilePage() {
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
                onRefresh: () async => _updateProfilePage(context),
                child: ListView(
                  children: [
                    _buildProfileInfos(context),
                    20.ph,
                    _buildSubsAndVisitedPlaces(context),
                    10.ph,
                    const MyFriendsMyPosts(),
                    BlocListener<ProfileBloc, ProfileState>(
                      listener: (context, state) {
                        final NotifierBloc notifierBloc =
                            context.read<NotifierBloc>();

                        if (state.status == ProfileStatus.error) {
                          notifierBloc.add(
                            AppendNotification(
                              notification: state.error?.getDescription() ??
                                  StringConstants().errorWhilePostingComment,
                              type: NotificationType.error,
                            ),
                          );
                        }

                        if (state.status == ProfileStatus.updated) {
                          notifierBloc.add(
                            AppendNotification(
                              notification: StringConstants().profileUpdated,
                              type: NotificationType.success,
                            ),
                          );
                        }
                      },
                      child: 0.ph,
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

  Future<void> _updateProfilePage(BuildContext context) async {
    BlocProvider.of<ProfileBloc>(context)
        .add(GetProfileEvent());
  }

  SizedBox _buildProfileInfos(BuildContext context) {
    return SizedBox(
      height: 220,
      width: MediaQuery.of(context).size.width,
      child: const Stack(
        children: [
          BannerPicture(
            isMyProfile: true,
          ),
          Positioned(
              bottom: 0,
              child: ProfileBanner(
                isMyProfile: true,
              )),
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
            height: 50,
            content: _buildFriendsCard(context),
          ),
          20.pw,
          CustomCard(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 50,
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
