import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/notifier_bloc/notification_type.dart';
import '../bloc/notifier_bloc/notifier_bloc.dart';
import '../bloc/notifier_bloc/notifier_event.dart';
import '../bloc/profile/profile_bloc.dart';
import '../component/friends_and_visited_widget.dart';
import '../component/my_friends_my_posts.dart';
import '../component/profile_infos.dart';
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
                    const ProfileInfos(isMyProfile: true),
                    20.ph,
                    const FriendsAndVisitedWidget(),
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
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
  }
}
