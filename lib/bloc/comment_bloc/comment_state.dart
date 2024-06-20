part of 'comment_bloc.dart';

enum CommentStatus { loading, notLoading, error, commentPosted }

class CommentState {
  const CommentState({
    this.commentResponse,
    this.status = CommentStatus.notLoading,
    this.error,
    this.commentsPerPage = 10,
    this.commentsPage = 0,
    this.hasMoreComments = true,
    this.searchMoreCommentsStatus = CommentStatus.notLoading,
    this.addCommentStatus = CommentStatus.notLoading,
  });

  CommentState copyWith({
    CommentResponse? commentResponse,
    CommentStatus? status,
    ApiError? error,
    int? commentsPerPage,
    int? commentsPage,
    bool? hasMoreComments,
    CommentStatus? searchMoreCommentsStatus,
    CommentStatus? addCommentStatus,
  }) {
    return CommentState(
      commentResponse: commentResponse ?? this.commentResponse,
      status: status ?? this.status,
      error: error ?? this.error,
      commentsPerPage: commentsPerPage ?? this.commentsPerPage,
      commentsPage: commentsPage ?? this.commentsPage,
      hasMoreComments: hasMoreComments ?? this.hasMoreComments,
      searchMoreCommentsStatus:
          searchMoreCommentsStatus ?? this.searchMoreCommentsStatus,
      addCommentStatus: addCommentStatus ?? this.addCommentStatus,
    );
  }

  final CommentResponse? commentResponse;
  final CommentStatus status;
  final ApiError? error;
  final int commentsPerPage;
  final int commentsPage;
  final bool hasMoreComments;
  final CommentStatus searchMoreCommentsStatus;
  final CommentStatus addCommentStatus;
}
