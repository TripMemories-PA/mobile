import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/post/post_service.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/string_constants.dart';
import '../object/city/city.dart';
import '../repository/post/post_repository.dart';
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
    return BlocProvider(
      create: (context) => PostBloc(
        postRepository: RepositoryProvider.of<PostRepository>(
          context,
        ), postService: PostService(),
      )..add(
          GetCityPostEvent(
            id: city.id,
            isRefresh: true,
          ),
        ),
      child: _PostListContent(
        cityId: city.id,
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
    final postBloc = context.read<PostBloc>();

    if (postBloc.state.status != PostStatus.loading) {
      postBloc.add(
        GetCityPostEvent(
          id: cityId,
        ),
      );
    }
  }

  Widget _buildPostList(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.selectedCityGetPostsStatus == PostStatus.notLoading) {
          if (state.selectedCityPosts.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ...state.selectedCityPosts.map((post) {
                    return Column(
                      children: [
                        PostCardLikable(post: post),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                  Center(
                    child: context.read<PostBloc>().state.getCityHasMorePosts
                        ? (context.read<PostBloc>().state.status !=
                                PostStatus.error
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
        } else if (state.selectedCityGetPostsStatus == PostStatus.loading) {
          return const Center(child: ShimmerPostAndMonumentResumeList());
        } else if (state.selectedCityGetPostsStatus == PostStatus.error) {
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

  void _getPostsRequest(
    BuildContext context,
  ) {
    context.read<PostBloc>().add(
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
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<PostBloc>()
                .add(GetCityPostEvent(isRefresh: true, id: cityId));
          },
          child: state.status == PostStatus.loading
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
