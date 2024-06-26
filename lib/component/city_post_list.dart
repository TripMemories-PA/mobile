import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/city_bloc/city_bloc.dart';
import '../constants/string_constants.dart';
import '../object/city/city.dart';
import '../object/post/post.dart';
import '../repository/city/cities_repository.dart';
import '../service/cities/cities_remote_data_source.dart';
import 'post_card.dart';
import 'shimmer/shimmer_post_and_monument_resume_list.dart';

class CityPostList extends HookWidget {
  const CityPostList({
    super.key,
    required this.city,
  });

  final City city;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          CityRepository(citiesRemoteDataSource: CityRemoteDataSource()),
      child: BlocProvider(
        create: (context) => CityBloc(
          cityRepository: RepositoryProvider.of<CityRepository>(
            context,
          ),
        )..add(
            GetCityPostEvent(
              id: city.id,
              isRefresh: true,
            ),
          ),
        child: _PostListContent(
          cityId: city.id,
        ),
      ),
    );
  }
}

class _PostListContent extends HookWidget {
  const _PostListContent({
    required this.cityId,
  });

  final int cityId;

  void _getPosts(BuildContext context) {
    final cityBloc = context.read<CityBloc>();

    if (cityBloc.state.status != CityStatus.loading) {
      cityBloc.add(
        GetCityPostEvent(
          id: cityId,
        ),
      );
    }
  }

  Widget _buildPostList(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        if (state.status == CityStatus.notLoading) {
          final List<Post> posts = state.selectedCityPosts;
          if (posts.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ...posts.map((post) {
                    return Column(
                      children: [
                        PostCardLikable(post: post),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                  Center(
                    child: context.read<CityBloc>().state.getCityHasMorePosts
                        ? (context.read<CityBloc>().state.status !=
                                CityStatus.error
                            ? const ShimmerPostAndMonumentResumeList()
                            : _buildErrorWidget(context))
                        : Text(StringConstants().noMorePosts),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(StringConstants().noPostYet));
          }
        } else if (state.selectedCityGetPostsStatus == CityStatus.loading) {
          return const Center(child: ShimmerPostAndMonumentResumeList());
        } else if (state.selectedCityGetPostsStatus == CityStatus.error) {
          return Center(
            child: Text(StringConstants().errorWhileLoadingPosts),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getPostsRequest(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getPostsRequest(BuildContext context,) {
    context.read<CityBloc>().add(
          GetCityPostEvent(
            id: cityId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController postScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (postScrollController.position.atEdge) {
            if (postScrollController.position.pixels != 0) {
              _getPosts(context);
            }
          }
        }

        postScrollController.addListener(createScrollListener);
        return () => postScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<CityBloc>()
                .add(GetCityPostEvent(isRefresh: true, id: cityId));
          },
          child: state.status == CityStatus.loading
              // TODO(nono): shimmer
              ? const Center(
                  child: ShimmerPostAndMonumentResumeList(),
                )
              : SingleChildScrollView(
                  controller: postScrollController,
                  child: _buildPostList(context),
                ),
        );
      },
    );
  }
}
