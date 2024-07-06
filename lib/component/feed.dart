import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/post/post_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/string_constants.dart';
import '../object/post.dart';
import '../repository/post/post_repository.dart';
import 'post_card.dart';
import 'shimmer/shimmer_post_and_monument_resume.dart';
import 'shimmer/shimmer_post_and_monument_resume_list.dart';

class FeedComponent extends HookWidget {
  const FeedComponent({
    super.key,
    this.userId,
    this.myPosts = false,
  });

  final int? userId;
  final bool myPosts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(
        postRepository: RepositoryProvider.of<PostRepository>(context),
        postService: PostService(),
      )..add(
          GetPostsEvent(
            isRefresh: true,
            myPosts: myPosts,
            userId: userId,
            isMyFeed: context.read<AuthBloc>().state.status ==
                AuthStatus.authenticated,
          ),
        ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          context.read<PostBloc>().add(
                GetPostsEvent(
                  isRefresh: true,
                  myPosts: myPosts,
                  userId: userId,
                  isMyFeed: state.status == AuthStatus.authenticated,
                ),
              );
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return _PostListContent(myPosts, userId);
          },
        ),
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
    final postBloc = context.read<PostBloc>();

    if (postBloc.state.status != PostStatus.loading) {
      postBloc.add(
        GetPostsEvent(
          myPosts: myPosts,
          userId: userId,
          isMyFeed:
              context.read<AuthBloc>().state.status == AuthStatus.authenticated,
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
            isMyFeed: context.read<AuthBloc>().state.status ==
                AuthStatus.authenticated,
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(
                      GetPostsEvent(
                        isRefresh: true,
                        myPosts: myPosts,
                        isMyFeed: context.read<AuthBloc>().state.status ==
                            AuthStatus.authenticated,
                      ),
                    );
              },
              child: state.status == PostStatus.loading
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
      },
    );
  }
}
