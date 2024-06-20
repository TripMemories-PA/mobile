import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/comment/model/response/get_comment_response/get_comment_response.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../repository/comment/comment_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({
    required this.commentRepository,
    required this.postId,
  }) : super(const CommentState()) {
    on<GetCommentsEvent>(
      (event, emit) async {
        emit(state.copyWith(status: CommentStatus.loading));
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
              commentResponse: commentResponse,
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
  }

  int postId;
  CommentRepository commentRepository;
}
