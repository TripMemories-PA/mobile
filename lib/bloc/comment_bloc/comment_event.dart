part of 'comment_bloc.dart';

sealed class CommentEvent {}

class GetCommentsEvent extends CommentEvent {
  GetCommentsEvent({
    this.isRefresh = false,
  });

  final bool isRefresh;
}

class AddCommentEvent extends CommentEvent {
  AddCommentEvent({
    required this.content,
    required this.postId,
  });

  final String content;
  final int postId;
}
