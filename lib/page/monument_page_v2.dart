import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../api/post/post_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/ticket_bloc/ticket_bloc.dart';
import '../component/map_mini.dart';
import '../component/post_card.dart';
import '../component/shimmer/shimmer_post_and_monument_resume.dart';
import '../component/ticket_card.dart';
import '../component/ticket_slider.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/poi/poi.dart';
import '../object/ticket.dart';
import '../repository/monument/monument_repository.dart';
import '../repository/post/post_repository.dart';
import '../repository/ticket/ticket_repository.dart';

class MonumentPageV2 extends HookWidget {
  const MonumentPageV2({super.key, required this.monument});

  final Poi monument;

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 4);
    return BlocProvider(
      create: (context) => MonumentBloc(
        monumentRepository: RepositoryProvider.of<MonumentRepository>(context),
      )..add(
          GetMonumentEvent(
            id: monument.id,
          ),
        ),
      child: BlocBuilder<MonumentBloc, MonumentState>(
        builder: (context, state) {
          return _PageContent(
            monument: monument,
            tabController: tabController,
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
      floatingActionButton:
          context.read<AuthBloc>().state.status == AuthStatus.authenticated
              ? FloatingActionButton(
                  onPressed: () =>
                      context.push(RouteName.editTweetPage, extra: monument),
                  child: const Icon(Icons.add),
                )
              : null,
      body: Stack(
        children: [
          DefaultTabController(
            length: 4,
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
                  SingleChildScrollView(
                    controller: monumentPostsScrollController,
                    child: _buildPostPart(),
                  ),
                  SingleChildScrollView(child: _buildActuPart()),
                  SingleChildScrollView(child: _buildShop(context)),
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
              Tab(text: StringConstants().actu),
              Tab(text: StringConstants().shop),
            ],
          ),
        ),
      ),
    );
  }

  void _getPosts(BuildContext context, bool isRefresh) {
    final monumentBloc = context.read<MonumentBloc>();

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

  Widget _buildPostPart() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text(
            '${StringConstants().lastPostsFrom} ${monument.name}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          15.ph,
          BlocProvider(
            create: (context) => PostBloc(
              postRepository: RepositoryProvider.of<PostRepository>(context),
              postService: PostService(),
            ),
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return BlocBuilder<MonumentBloc, MonumentState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        ...context
                            .read<MonumentBloc>()
                            .state
                            .selectedMonumentPosts
                            .map(
                              (post) => Column(
                                children: [
                                  PostCardLikable(
                                    post: post,
                                  ),
                                  20.ph,
                                ],
                              ),
                            ),
                        Center(
                          child: context
                                  .read<MonumentBloc>()
                                  .state
                                  .getMonumentsHasMorePosts
                              ? (context.read<MonumentBloc>().state.status !=
                                      MonumentStatus.error
                                  ? const ShimmerPostAndMonumentResume()
                                  : _buildErrorWidget(context))
                              : Text(StringConstants().noMorePosts),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActuPart() {
    return Center(
      child: Text(StringConstants().actu),
    );
  }

  Widget _buildShop(BuildContext context) {
    return Center(
      child: Column(
        children: [
          20.ph,
          Text(
            StringConstants().doNotWaitToBuy,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          20.ph,
          BlocProvider(
            create: (context) => TicketBloc(
              ticketRepository: RepositoryProvider.of<TicketRepository>(
                context,
              ),
            )..add(
                GetTicketsEvent(monumentId: monument.id),
              ),
            child: BlocBuilder<TicketBloc, TicketState>(
              builder: (context, state) {
                final List<Ticket>? tickets = state.tickets;
                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<TicketBloc>()
                        .add(GetTicketsEvent(monumentId: monument.id));
                  },
                  child: state.status == TicketStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : tickets == null
                          ? Center(
                              child: Text(
                                  StringConstants().noTicketForThisMonument))
                          : (tickets.length == 1
                              ? TicketCardAdmin(article: tickets[0])
                              : TicketTabView(
                                  tickets: tickets,
                                )),
                );
              },
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
