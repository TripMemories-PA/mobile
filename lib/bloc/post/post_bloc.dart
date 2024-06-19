import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/error/specific_error/auth_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/post/i_post_service.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import '../../repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required PostRepository postRepository,
    required this.postService,
  }) : super(const PostState()) {
    on<GetMyPostsEvent>(
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
          final String? authToken = await AuthTokenHandler().getAuthToken();
          if (authToken == null) {
            emit(
              state.copyWith(
                status: PostStatus.error,
                error: AuthError.notAuthenticated(),
              ),
            );
            return;
          }
          final GetAllPostsResponse myPosts = await postRepository.getMyPosts(
            page: event.isRefresh ? 1 : state.postsPage + 1,
            perPage: state.postsPerPage,
          );
          emit(
            state.copyWith(
              posts: event.isRefresh
                  ? myPosts
                  : state.posts?.copyWith(
                      data: [
                        ...state.posts!.data,
                        ...myPosts.data,
                      ],
                    ),
              status: PostStatus.notLoading,
              getMorePostsStatus: PostStatus.notLoading,
              postsPage: event.isRefresh ? 1 : state.postsPage + 1,
              hasMorePosts: myPosts.data.length == state.postsPerPage,
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
          add(GetMyPostsEvent(isRefresh: true));
        }
      },
    );
  }

  final IPostService postService;
}
