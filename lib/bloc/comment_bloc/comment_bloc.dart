import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/comment/i_comment_service.dart';
import '../../api/comment/model/query/post_comment_query.dart';
import '../../api/comment/model/response/get_comment_response.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../object/comment.dart';
import '../../repository/comment/i_comment_repository.dart';
import '../post/post_bloc.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({
    required this.commentRepository,
    required this.commentService,
    required this.postId,
    required this.postBloc,
  }) : super(const CommentState()) {
    on<GetCommentsEvent>(
      (event, emit) async {
        if (event.needLoading) {
          if (event.isRefresh) {
            emit(state.copyWith(status: CommentStatus.loading));
          } else {
            emit(
              state.copyWith(searchMoreCommentsStatus: CommentStatus.loading),
            );
          }
        }
        try {
          final CommentResponse commentResponse =
              await commentRepository.getComments(
            postId: postId,
            page: event.isRefresh ? 1 : state.commentsPage + 1,
            perPage: state.commentsPerPage,
          );

          emit(
            state.copyWith(
              status: CommentStatus.notLoading,
              searchMoreCommentsStatus: CommentStatus.notLoading,
              commentResponse: event.isRefresh
                  ? commentResponse
                  : state.commentResponse?.copyWith(
                      data: [
                        ...state.commentResponse!.data,
                        ...commentResponse.data,
                      ],
                    ),
              commentsPage: event.isRefresh ? 1 : state.commentsPage + 1,
              hasMoreComments:
                  commentResponse.data.length == state.commentsPerPage,
            ),
          );
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(status: CommentStatus.error, error: e.apiError),
            );
          } else {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );

    on<AddCommentEvent>(
      (event, emit) async {
        emit(state.copyWith(addCommentStatus: CommentStatus.loading));
        try {
          final PostCommentQuery query = PostCommentQuery(
            postId: postId,
            content: event.content,
          );
          await commentService.commentPost(
            query: query,
          );

          emit(state.copyWith(addCommentStatus: CommentStatus.commentPosted));
          add(GetCommentsEvent(isRefresh: true, needLoading: false));
          emit(state.copyWith(addCommentStatus: CommentStatus.notLoading));
          postBloc.add(IncrementCommentCounterEvent(postId));
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                addCommentStatus: CommentStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );

    on<LikeCommentEvent>(
      (event, emit) async {
        try {
          await commentService.likeComment(commentId: event.commentId);
          List<Comment>? comments = state.commentResponse?.data;
          if (comments != null) {
            comments = comments.map((comment) {
              if (comment.id == event.commentId) {
                comment = comment.copyWith(
                  isLiked: true,
                  likesCount: comment.likesCount + 1,
                );
              }
              return comment;
            }).toList();

            emit(
              state.copyWith(
                commentResponse:
                    state.commentResponse?.copyWith(data: comments),
              ),
            );
            postBloc.add(IncrementLikeCounterEvent(postId));
          }
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e is CustomException
                    ? e.apiError
                    : ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );

    on<DislikeCommentEvent>(
      (event, emit) async {
        try {
          await commentService.dislikeComment(commentId: event.commentId);
          List<Comment>? comments = state.commentResponse?.data;
          if (comments != null) {
            comments = comments.map((comment) {
              if (comment.id == event.commentId) {
                comment = comment.copyWith(
                  isLiked: false,
                  likesCount: comment.likesCount - 1,
                );
              }
              return comment;
            }).toList();
            emit(
              state.copyWith(
                commentResponse:
                    state.commentResponse?.copyWith(data: comments),
              ),
            );
            postBloc.add(DecrementLikeCounterEvent(postId));
          }
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e is CustomException
                    ? e.apiError
                    : ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );

    on<DeleteCommentEvent>(
      (event, emit) async {
        try {
          await commentService.deleteComment(commentId: event.commentId);
          List<Comment>? comments = state.commentResponse?.data;
          if (comments != null) {
            comments = comments
                .where((comment) => comment.id != event.commentId)
                .toList();
            emit(
              state.copyWith(
                commentResponse: state.commentResponse?.copyWith(
                  data: comments,
                ),
              ),
            );
            postBloc.add(DecrementCommentCounterEvent(postId));
          }
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e is CustomException
                    ? e.apiError
                    : ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );

    on<ReportCommentEvent>(
      (event, emit) async {
        try {
          await commentService.reportComment(commentId: event.commentId);
          final List<Comment> updatedComments =
              state.commentResponse!.data.map((comment) {
            if (comment.id == event.commentId) {
              comment = comment.copyWith(isReported: true);
            }
            return comment;
          }).toList();
          emit(
            state.copyWith(
              status: CommentStatus.reported,
              commentResponse:
                  state.commentResponse?.copyWith(data: updatedComments),
            ),
          );
        } catch (e) {
          if (e is CustomException) {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e.apiError,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CommentStatus.error,
                error: e is CustomException
                    ? e.apiError
                    : ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );
  }

  int postId;
  ICommentRepository commentRepository;
  ICommentService commentService;
  PostBloc postBloc;
}
