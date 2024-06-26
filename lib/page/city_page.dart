import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../api/post/post_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/city_bloc/city_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../component/monument_list.dart';
import '../component/shimmer/shimmer_post_and_monument_resume.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/city/city.dart';
import '../repository/city/cities_repository.dart';
import '../repository/post/post_repository.dart';
import '../service/cities/cities_remote_data_source.dart';
import '../service/post/post_remote_data_source.dart';

class CityPage extends HookWidget {
  const CityPage({super.key, required this.city});

  final City city;

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 3);
    return RepositoryProvider(
      create: (context) => CityRepository(
        citiesRemoteDataSource: CityRemoteDataSource(),
      ),
      child: BlocProvider(
        create: (context) => CityBloc(
          cityRepository: RepositoryProvider.of<CityRepository>(context),
        )..add(
            GetCityPoiEvent(id: city.id, isRefresh: true),
          ),
        child: BlocBuilder<CityBloc, CityState>(
          builder: (context, state) {
            return _PageContent(
              city: city,
              tabController: tabController,
            );
          },
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

class _PageContent extends HookWidget {
  const _PageContent({
    required this.city,
    required this.tabController,
  });

  final City city;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final ScrollController cityPostsScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (cityPostsScrollController.position.atEdge) {
            if (cityPostsScrollController.position.pixels != 0) {
              _getPosts(context, false);
            }
          }
        }

        cityPostsScrollController.addListener(createScrollListener);
        return () =>
            cityPostsScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return Scaffold(
      floatingActionButton:
          context.read<AuthBloc>().state.status == AuthStatus.authenticated
              ? FloatingActionButton(
                  onPressed: () =>
                      context.push(RouteName.editTweetPage, extra: city),
                  child: const Icon(Icons.add),
                )
              : null,
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
                  SingleChildScrollView(
                    controller: cityPostsScrollController,
                    child: _buildMonumentPart(),
                  ),
                  SingleChildScrollView(child: _buildActuPart()),
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
              Tab(text: StringConstants().monuments),
              Tab(text: StringConstants().actu),
            ],
          ),
        ),
      ),
    );
  }

  void _getPosts(BuildContext context, bool isRefresh) {
    final cityBloc = context.read<CityBloc>();

    if (cityBloc.state.selectedCityGetMonumentsStatus != CityStatus.loading) {
      cityBloc.add(
        GetCityPoiEvent(
          id: city.id,
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
            city.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
          ),
          10.ph,
          Text(
            city.zipCode,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonumentPart() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text(
            '${StringConstants().lastPostsFrom} ${city.name}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          15.ph,
          RepositoryProvider(
            create: (context) => PostRepository(
              postRemoteDataSource: PostRemoteDataSource(),
            ),
            child: BlocProvider(
              create: (context) => PostBloc(
                postRepository: RepositoryProvider.of<PostRepository>(context),
                postService: PostService(),
              ),
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  return BlocBuilder<CityBloc, CityState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          MonumentList(
                            monuments: context
                                .read<CityBloc>()
                                .state
                                .selectedCityMonument,
                          ),
                          Center(
                            child: context
                                    .read<CityBloc>()
                                    .state
                                    .getCityHasMoreMonuments
                                ? (context.read<CityBloc>().state.status !=
                                        CityStatus.error
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
          ),
        ],
      ),
    );
  }

  Widget _buildActuPart() {
    return const Center(
      child: Text('Actu'),
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
            imageUrl: city.cover?.url ?? '',
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
