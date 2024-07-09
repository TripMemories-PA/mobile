import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../api/post/post_service.dart';
import '../api/profile/profile_service.dart';
import '../api/ticket/ticket_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/ticket_bloc/ticket_bloc.dart';
import '../component/my_friends_component.dart';
import '../component/my_post_component.dart';
import '../component/my_tickets_component.dart';
import '../component/profile_infos.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../repository/post/post_repository.dart';
import '../repository/profile/profile_repository.dart';
import '../repository/ticket/ticket_repository.dart';
import '../utils/messenger.dart';
import 'login_page.dart';

class ProfilePagePoi extends HookWidget {
  const ProfilePagePoi({super.key, this.userId});

  final int? userId;

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 3);
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

  BlocProvider<ProfileBloc> _buildProfilePage(
    TabController tabController,
  ) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        profileService: ProfileService(),
      )..add(GetProfileEvent(userId: userId)),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return _buildScaffold(
            tabController,
            context,
          );
        },
      ),
    );
  }

  Scaffold _buildScaffold(
    TabController tabController,
    BuildContext context,
  ) {
    return Scaffold(
      floatingActionButton:
          context.read<AuthBloc>().state.status == AuthStatus.authenticated &&
                  userId == null
              ? FloatingActionButton(
                  onPressed: () => context.push(RouteName.editTweetPage),
                  child: const Icon(Icons.add),
                )
              : null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    _buildUserProfileInfosSliverAppBar(context),
                    if (userId == null &&
                        context.read<AuthBloc>().state.user?.userTypeId != 3)
                      _buildSliverMenuForPostsAndFriends(
                        tabController,
                        context,
                      ),
                  ];
                },
                body: context.read<AuthBloc>().state.user?.userTypeId == 3
                    ? const SizedBox.shrink()
                    : MyPostsAndMyFriends(
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
    BuildContext context,
  ) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CustomSliverAppBarDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            unselectedLabelColor: MyColors.darkGrey,
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: StringConstants().myFriends),
              Tab(text: StringConstants().myPosts),
              Tab(text: StringConstants().myTickets),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildUserProfileInfosSliverAppBar(BuildContext context) {
    return SliverAppBar(
      leading: userId != null
          ? IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => context.pop(),
            )
          : null,
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
            10.ph,
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
                if (state.status == ProfileStatus.postDeleted) {
                  Messenger.showSnackBarSuccess(
                    StringConstants().postDeleted,
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
    this.userId,
    required this.tabController,
  });

  final int? userId;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final int? tmpUserId = userId;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: tmpUserId == null
          ? TabBarView(
              controller: tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<ProfileBloc>()
                        .add(GetFriendsEvent(isRefresh: true));
                  },
                  child: const SingleChildScrollView(
                    child: MyFriendsComponent(),
                  ),
                ),
                _buildMyPostsPart(),
                _buildMyTicketsPart(),
              ],
            )
          : _buildOtherUsersPosts(tmpUserId),
    );
  }

  BlocProvider<PostBloc> _buildMyPostsPart() {
    return BlocProvider(
      create: (context) => PostBloc(
        postRepository: RepositoryProvider.of<PostRepository>(
          context,
        ),
        postService: PostService(),
      )..add(
          GetPostsEvent(
            isRefresh: true,
            myPosts: true,
          ),
        ),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<PostBloc>()
                  .add(GetPostsEvent(isRefresh: true, myPosts: true));
            },
            child: const SingleChildScrollView(
              child: MyPostsComponents(),
            ),
          );
        },
      ),
    );
  }

  BlocProvider<TicketBloc> _buildMyTicketsPart() {
    return BlocProvider(
      create: (context) => TicketBloc(
        ticketRepository: RepositoryProvider.of<TicketRepository>(
          context,
        ),
        ticketService: TicketService(),
      )..add(
          GetMyTicketsEvent(),
        ),
      child: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TicketBloc>().add(GetMyTicketsEvent());
            },
            child: const SingleChildScrollView(
              child: MyTicketsComponent(),
            ),
          );
        },
      ),
    );
  }

  BlocProvider<PostBloc> _buildOtherUsersPosts(int userId) {
    return BlocProvider(
      create: (context) => PostBloc(
        postRepository: RepositoryProvider.of<PostRepository>(
          context,
        ),
        postService: PostService(),
      )..add(
          GetPostsEvent(
            isRefresh: true,
            userId: userId,
          ),
        ),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<PostBloc>()
                  .add(GetPostsEvent(isRefresh: true, userId: userId));
            },
            child: const SingleChildScrollView(
              child: MyPostsComponents(),
            ),
          );
        },
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
