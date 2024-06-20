part of 'post_bloc.dart';

enum PostStatus {
  initial,
  loading,
  notLoading,
  updated,
  error,
  postDeleted,
}

class PostState {
  const PostState({
    this.status = PostStatus.initial,
    this.getMorePostsStatus = PostStatus.initial,
    this.error,
    this.posts,
    this.postsPerPage = 10,
    this.postsPage = 0,
    this.hasMorePosts = true,
  });

  PostState copyWith({
    PostStatus? status,
    PostStatus? getMorePostsStatus,
    ApiError? error,
    GetAllPostsResponse? posts,
    int? postsPage,
    int? postsPerPage,
    bool? hasMorePosts,
  }) {
    return PostState(
      status: status ?? this.status,
      getMorePostsStatus: getMorePostsStatus ?? this.getMorePostsStatus,
      error: error,
      posts: posts ?? this.posts,
      postsPage: postsPage ?? this.postsPage,
      postsPerPage: postsPerPage ?? this.postsPerPage,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
    );
  }

  final PostStatus status;
  final PostStatus getMorePostsStatus;
  final ApiError? error;
  final int postsPerPage;
  final int postsPage;
  final bool hasMorePosts;
  final GetAllPostsResponse? posts;
}
