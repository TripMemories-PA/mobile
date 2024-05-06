import 'dart:math' as math;

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
import '../component/my_friends_component.dart';
import '../component/my_post_component.dart';
import '../component/profile_infos.dart';
import '../constants/string_constants.dart';
import '../repository/profile_repository.dart';
import '../service/profile_remote_data_source.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.userId});

  final String? userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // if user is null i will try to display my own profile
        // that is why i check if the user is authenticated
        if (widget.userId == null &&
            context.read<AuthBloc>().state.status != AuthStatus.authenticated) {
          return const LoginPage();
        }
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
        )..add(GetProfileEvent(userId: widget.userId)),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return _buildScaffold();
          },
        ),
      ),
    );
  }

  Scaffold _buildScaffold() {
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
                    if (widget.userId == null)
                      _buildSliverMenuForPostsAndFriends(),
                  ];
                },
                body: _buildMyPostsAndMyFriends(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildMyPostsAndMyFriends() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: widget.userId == null
          ? TabBarView(
              controller: _tabController,
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

  SliverPersistentHeader _buildSliverMenuForPostsAndFriends() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: ColoredBox(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
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
              isMyProfile: widget.userId == null,
            ),
            const SizedBox(height: 20),
            const FriendsAndVisitedWidget(),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
