import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/notifier_bloc/notification_type.dart';
import '../bloc/notifier_bloc/notifier_bloc.dart';
import '../bloc/notifier_bloc/notifier_event.dart';
import '../bloc/profile/profile_bloc.dart';
import '../component/friends_and_visited_widget.dart';
import '../component/my_friends_component.dart';
import '../component/my_post_component.dart';
import '../component/profile_infos.dart';
import '../constants/string_constants.dart';
import '../repository/profile_repository.dart';
import '../service/profile_remote_data_source.dart';
import 'login_page.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key, this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 2);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // if user is null i will try to display my own profile
        // that is why i check if the user is authenticated
        if (userId == null &&
            context.read<AuthBloc>().state.status != AuthStatus.authenticated) {
          return const LoginPage();
        }
        return _buildProfilePage(tabController);
      },
    );
  }

  RepositoryProvider<ProfileRepository> _buildProfilePage(
    TabController tabController,
  ) {
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
            return _buildScaffold(
              tabController,
            );
          },
        ),
      ),
    );
  }

  Scaffold _buildScaffold(
    TabController tabController,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    _buildUserProfileInfosSliverAppBar(),
                    if (userId == null)
                      _buildSliverMenuForPostsAndFriends(tabController),
                  ];
                },
                body: _buildMyPostsAndMyFriends(
                  tabController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildMyPostsAndMyFriends(
    TabController tabController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: userId == null
          ? TabBarView(
              controller: tabController,
              children: [
                MyFriendsComponentScrollable(),
                const SingleChildScrollView(
                  child: MyPostsComponents(),
                ),
              ],
            )
          : const Center(
              child: Text(
                'NO DATA TO DISPLAY FOR NOW: SCREEN INC',
              ),
            ),
    );
  }

  SliverPersistentHeader _buildSliverMenuForPostsAndFriends(
    TabController tabController,
  ) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CustomSliverAppBarDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: ColoredBox(
          color: Colors.white,
          child: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Mes amis'),
              Tab(text: 'Mes posts'),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildUserProfileInfosSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      leading: const SizedBox.shrink(),
      flexibleSpace: FlexibleSpaceBar(
        background: ListView(
          children: [
            ProfileInfos(
              isMyProfile: userId == null,
            ),
            const SizedBox(height: 20),
            FriendsAndVisitedWidget(
              itIsMe: userId == null,
            ),
            const SizedBox(height: 10),
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                final NotifierBloc notifierBloc = context.read<NotifierBloc>();

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
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFriendsComponentScrollable extends StatelessWidget {
  MyFriendsComponentScrollable({
    super.key,
  });

  final ScrollController friendsScrollController = ScrollController();

  void _getNextFriends(BuildContext context) {
    final tweetBloc = context.read<ProfileBloc>();

    if (tweetBloc.state.status != ProfileStatus.loading) {
      tweetBloc.add(
        GetFriendsEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    friendsScrollController.addListener(() {
      if (friendsScrollController.position.atEdge) {
        if (friendsScrollController.position.pixels != 0) {
          _getNextFriends(context);
        }
      }
    });
    return SingleChildScrollView(
      controller: friendsScrollController,
      child: const MyFriendsComponent(),
    );
  }
}

class _CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _CustomSliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_CustomSliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
