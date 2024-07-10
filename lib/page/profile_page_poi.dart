import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../component/edit_quizz.dart';
import '../component/map_mini.dart';
import '../component/poi_feed.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/poi/poi.dart';
import '../repository/monument/monument_repository.dart';
import 'login_page.dart';

class ProfilePagePoi extends HookWidget {
  const ProfilePagePoi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 3);
    final int? poiId = context.read<AuthBloc>().state.user?.poiId;
    if (poiId == null) {
      context.read<AuthBloc>().add(const ChangeToLoggedOutStatus());
      return const LoginPage();
    }
    return BlocProvider(
      create: (context) => MonumentBloc(
        monumentRepository: RepositoryProvider.of<MonumentRepository>(context),
      )..add(
          GetMonumentEvent(
            id: poiId,
          ),
        ),
      child: BlocBuilder<MonumentBloc, MonumentState>(
        builder: (context, state) {
          if (state.status == MonumentStatus.loading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final Poi? monument = state.selectedMonument;
          if (monument == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  StringConstants().errorOccurred,
                ),
              ),
            );
          } else {
            return _PageContent(
              monument: monument,
              tabController: tabController,
            );
          }
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

class _PageContent extends HookWidget {
  const _PageContent({
    required this.monument,
    required this.tabController,
  });

  final Poi monument;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final ScrollController monumentPostsScrollController =
        useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (monumentPostsScrollController.position.atEdge) {
            if (monumentPostsScrollController.position.pixels != 0) {
              _getPosts(context, false);
            }
          }
        }

        monumentPostsScrollController.addListener(createScrollListener);
        return () =>
            monumentPostsScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return Scaffold(
      body: Stack(
        children: [
          DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  _buildHeader(context),
                  _buildSliverMenuForPostsAndFriends(),
                ];
              },
              body: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(child: _buildDescription(context)),
                  PoiFeed(
                    monumentId: context.read<AuthBloc>().state.user?.poiId ?? 0,
                  ),
                  const SingleChildScrollView(
                    child: EditQuiz(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverPersistentHeader _buildSliverMenuForPostsAndFriends() {
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
            tabs: [
              Tab(text: StringConstants().description),
              Tab(text: StringConstants().posts),
              Tab(text: StringConstants().quiz),
            ],
          ),
        ),
      ),
    );
  }

  void _getPosts(BuildContext context, bool isRefresh) {
    final monumentBloc = context.read<MonumentBloc>();
//TODO
    if (monumentBloc.state.selectedPostGetMonumentsStatus !=
        MonumentStatus.loading) {
      monumentBloc.add(
        GetMonumentPostsEvent(
          id: monument.id,
          isRefresh: isRefresh,
        ),
      );
    }
  }

  Padding _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text(
            monument.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
          ),
          15.ph,
          Text(
            monument.city?.name ?? '',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          15.ph,
          Text(
            monument.description ?? '',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          15.ph,
          Center(
            child: MiniMap(
              poi: monument,
              width: MediaQuery.of(context).size.width - 40,
              height: 300,
            ),
          ),
          10.ph,
          Text(
            monument.address ?? '',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            monument.city?.name ?? '',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            monument.city?.zipCode ?? '',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getPosts(context, true),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  SliverAppBar _buildHeader(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () => context.pop(),
      ),
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          height: 180,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: monument.cover.url,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
