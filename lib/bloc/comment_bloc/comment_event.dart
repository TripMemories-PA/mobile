part of 'comment_bloc.dart';

sealed class CommentEvent {}

class GetCommentsEvent extends CommentEvent {
  GetCommentsEvent({
    this.isRefresh = false,
    this.needLoading = true,
  });

  final bool isRefresh;
  final bool needLoading;
}

class AddCommentEvent extends CommentEvent {
  AddCommentEvent({
    required this.content,
    required this.postId,
  });

  final String content;
  final int postId;
}

class LikeCommentEvent extends CommentEvent {
  LikeCommentEvent(this.commentId);

  final int commentId;
}

class DislikeCommentEvent extends CommentEvent {
  DislikeCommentEvent(this.commentId);

  final int commentId;
}

class DeleteCommentEvent extends CommentEvent {
  DeleteCommentEvent(this.commentId);

  final int commentId;
}

class ReportCommentEvent extends CommentEvent {
  ReportCommentEvent(this.commentId);

  final int commentId;
}
