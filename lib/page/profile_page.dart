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

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.userId,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final String userId;

  @override
  Widget build(BuildContext context) {
    return _buildMyProfilePage();
  }

  BlocBuilder<AuthBloc, AuthState> _buildMyProfilePage() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return _buildProfilePage();
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
        )..add(GetProfileEvent(userId: userId)),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: ListView(
                children: [
                  const ProfileInfos(),
                  const SizedBox(
                    height: 20,
                  ),
                  const FriendsAndVisitedWidget(),
                  const SizedBox(
                    height: 10,
                  ),
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
            );
          },
        ),
      ),
    );
  }
}
