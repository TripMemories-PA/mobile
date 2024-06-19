import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/profile/profile_bloc.dart';
import '../component/my_friends_component.dart';
import '../component/my_post_component.dart';
import '../component/profile_infos.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../repository/profile_repository.dart';
import '../service/profile/profile_remote_data_source.dart';
import '../utils/messenger.dart';
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
                    _buildUserProfileInfosSliverAppBar(context),
                    if (userId == null)
                      _buildSliverMenuForPostsAndFriends(tabController),
                  ];
                },
                body: MyPostsAndMyFriends(
                  userId: userId,
                  tabController: tabController,
                ),
              ),
            ),
          ],
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
            unselectedLabelColor: MyColors.darkGrey,
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

  SliverAppBar _buildUserProfileInfosSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        background: ListView(
          children: [
            SizedBox(
              height: 300,
              child: ProfileInfos(
                isMyProfile: userId == null,
              ),
            ),
            const SizedBox(height: 10),
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state.status == ProfileStatus.error) {
                  Messenger.showSnackBarError(
                    state.error?.getDescription() ??
                        StringConstants().errorWhilePostingComment,
                  );
                }
                if (state.status == ProfileStatus.updated) {
                  Messenger.showSnackBarSuccess(
                    StringConstants().profileUpdated,
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

class MyPostsAndMyFriends extends HookWidget {
  const MyPostsAndMyFriends({
    super.key,
    required this.userId,
    required this.tabController,
  });

  final String? userId;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: userId == null
          ? TabBarView(
              controller: tabController,
              children: const [
                SingleChildScrollView(
                  child: MyFriendsComponent(),
                ),
                SingleChildScrollView(
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
