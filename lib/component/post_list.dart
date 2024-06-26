import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/post/post_service.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/string_constants.dart';
import '../object/post/post.dart';
import '../repository/post/post_repository.dart';
import '../service/post/post_remote_data_source.dart';
import 'post_card.dart';
import 'shimmer/shimmer_post_and_monument_resume.dart';
import 'shimmer/shimmer_post_and_monument_resume_list.dart';

class PostList extends HookWidget {
  const PostList({
    super.key,
    this.userId,
    this.myPosts = false,
  });

  final int? userId;
  final bool myPosts;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          PostRepository(postRemoteDataSource: PostRemoteDataSource()),
      child: BlocProvider(
        create: (context) => PostBloc(
          postRepository: RepositoryProvider.of<PostRepository>(
            context,
          ),
          postService: PostService(),
        )..add(
            GetPostsEvent(
              isRefresh: true,
              myPosts: myPosts,
              userId: userId,
            ),
          ),
        child: _PostListContent(myPosts, userId),
      ),
    );
  }
}

class _PostListContent extends HookWidget {
  const _PostListContent(
    this.myPosts,
    this.userId,
  );

  final bool myPosts;
  final int? userId;

  void _getPosts(BuildContext context) {
    final tweetBloc = context.read<PostBloc>();

    if (tweetBloc.state.status != PostStatus.loading) {
      tweetBloc.add(
        GetPostsEvent(
          myPosts: myPosts,
          userId: userId,
        ),
      );
    }
  }

  Widget _buildPostList(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.status == PostStatus.notLoading) {
          final List<Post>? posts = state.posts?.data;
          if (posts != null && posts.isNotEmpty) {
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
                    child: context.read<PostBloc>().state.hasMorePosts
                        ? (context.read<PostBloc>().state.status !=
                                PostStatus.error
                            ? const ShimmerPostAndMonumentResume()
                            : _buildErrorWidget(context))
                        : Text(StringConstants().noMorePosts),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(StringConstants().noPostYet));
          }
        } else if (state.getMorePostsStatus == PostStatus.loading) {
          return const Center(child: ShimmerPostAndMonumentResume());
        } else if (state.getMorePostsStatus == PostStatus.error) {
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

  void _getPostsRequest(BuildContext context) {
    context.read<PostBloc>().add(
          GetPostsEvent(
            isRefresh: true,
            myPosts: myPosts,
            userId: userId,
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
                .add(GetPostsEvent(isRefresh: true, myPosts: myPosts));
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
