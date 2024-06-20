import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/post/i_post_service.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/post/post.dart';
import '../../repository/post/i_post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required this.postRepository,
    required this.postService,
  }) : super(const PostState()) {
    on<GetPostsEvent>(
      (event, emit) async {
        if (event.isRefresh) {
          emit(state.copyWith(status: PostStatus.loading));
        } else {
          emit(
            state.copyWith(
              getMorePostsStatus: PostStatus.loading,
            ),
          );
        }
        try {
          final GetAllPostsResponse posts = event.myPosts
              ? await postRepository.getMyPosts(
                  page: event.isRefresh ? 1 : state.postsPage + 1,
                  perPage: state.postsPerPage,
                )
              : await postRepository.getPosts(
                  page: event.isRefresh ? 1 : state.postsPage + 1,
                  perPage: state.postsPerPage,
                  userId: event.userId,
                );
          emit(
            state.copyWith(
              posts: event.isRefresh
                  ? posts
                  : state.posts?.copyWith(
                      data: [
                        ...state.posts!.data,
                        ...posts.data,
                      ],
                    ),
              status: PostStatus.notLoading,
              getMorePostsStatus: PostStatus.notLoading,
              postsPage: event.isRefresh ? 1 : state.postsPage + 1,
              hasMorePosts: posts.data.length == state.postsPerPage,
            ),
          );
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );

    on<DeletePostEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: PostStatus.loading));
          await postService.deletePost(postId: event.postId);
          emit(state.copyWith(status: PostStatus.postDeleted));
          emit(
            state.copyWith(
              posts: state.posts?.copyWith(
                data: state.posts!.data
                    .where((post) => post.id != event.postId)
                    .toList(),
              ),
            ),
          );
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: ApiError.errorOccurred(),
              ),
            );
          }
          add(GetPostsEvent(isRefresh: true, myPosts: true));
        }
      },
    );

    on<LikePostEvent>(
      (event, emit) async {
        try {
          await postService.likePost(postId: event.postId);
          GetAllPostsResponse? data = state.posts;
          if (data != null) {
            final List<Post> posts = data.data.map((post) {
              if (post.id == event.postId) {
                post = post.copyWith(
                  isLiked: true,
                  likesCount: post.likesCount + 1,
                );
              }
              return post;
            }).toList();
            data = data.copyWith(data: posts);
            emit(state.copyWith(posts: data));
          }
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: ApiError.errorOccurred(),
              ),
            );
          }
          add(GetPostsEvent(isRefresh: true));
        }
      },
    );

    on<DislikePostEvent>(
      (event, emit) async {
        try {
          await postService.dislikePost(postId: event.postId);
          GetAllPostsResponse? data = state.posts;
          if (data != null) {
            final List<Post> posts = data.data.map((post) {
              if (post.id == event.postId) {
                post = post.copyWith(
                  isLiked: false,
                  likesCount: post.likesCount - 1,
                );
              }
              return post;
            }).toList();
            data = data.copyWith(data: posts);
            emit(state.copyWith(posts: data));
          }
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: ApiError.errorOccurred(),
              ),
            );
          }
          add(GetPostsEvent(isRefresh: true));
        }
      },
    );

    on<IncrementCommentCounterEvent>(
      (event, emit) async {
        GetAllPostsResponse? data = state.posts;
        if (data != null) {
          final List<Post> posts = data.data.map((post) {
            if (post.id == event.postId) {
              post = post.copyWith(
                commentsCount: post.commentsCount + 1,
              );
            }
            return post;
          }).toList();
          data = data.copyWith(data: posts);
          emit(state.copyWith(posts: data));
        }
      },
    );

    on<DecrementCommentCounterEvent>(
      (event, emit) async {
        GetAllPostsResponse? data = state.posts;
        if (data != null) {
          final List<Post> posts = data.data.map((post) {
            if (post.id == event.postId) {
              post = post.copyWith(
                commentsCount: post.commentsCount - 1,
              );
            }
            return post;
          }).toList();
          data = data.copyWith(data: posts);
          emit(state.copyWith(posts: data));
        }
      },
    );

    on<IncrementLikeCounterEvent>(
      (event, emit) async {
        GetAllPostsResponse? data = state.posts;
        if (data != null) {
          final List<Post> posts = data.data.map((post) {
            if (post.id == event.postId) {
              post = post.copyWith(
                likesCount: post.likesCount + 1,
              );
            }
            return post;
          }).toList();
          data = data.copyWith(data: posts);
          emit(state.copyWith(posts: data));
        }
      },
    );

    on<DecrementLikeCounterEvent>(
      (event, emit) async {
        GetAllPostsResponse? data = state.posts;
        if (data != null) {
          final List<Post> posts = data.data.map((post) {
            if (post.id == event.postId) {
              post = post.copyWith(
                likesCount: post.likesCount - 1,
              );
            }
            return post;
          }).toList();
          data = data.copyWith(data: posts);
          emit(state.copyWith(posts: data));
        }
      },
    );
  }

  final IPostRepository postRepository;
  final IPostService postService;
}
