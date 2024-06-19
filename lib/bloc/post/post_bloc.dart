import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/post/i_post_service.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/post/post.dart';
import '../../repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required PostRepository postRepository,
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
          emit(
            state.copyWith(
              status: PostStatus.error,
              error: e is CustomException ? e.apiError : ApiError.unknown(),
            ),
          );
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
          emit(
            state.copyWith(
              status: PostStatus.error,
              error: e is CustomException ? e.apiError : ApiError.unknown(),
            ),
          );
          add(GetPostsEvent(isRefresh: true, myPosts: true));
        }
      },
    );

    on<LikePostEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: PostStatus.loading));
          await postService.likePost(postId: event.postId);
          emit(state.copyWith(status: PostStatus.notLoading));
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
          emit(
            state.copyWith(
              status: PostStatus.error,
              error: e is CustomException ? e.apiError : ApiError.unknown(),
            ),
          );
          add(GetPostsEvent(isRefresh: true));
        }
      },
    );

    on<DislikePostEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: PostStatus.loading));
          await postService.dislikePost(postId: event.postId);
          emit(state.copyWith(status: PostStatus.notLoading));
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
          emit(
            state.copyWith(
              status: PostStatus.error,
              error: e is CustomException ? e.apiError : ApiError.unknown(),
            ),
          );
          add(GetPostsEvent(isRefresh: true));
        }
      },
    );
  }

  final IPostService postService;
}
