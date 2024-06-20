part of 'comment_bloc.dart';

sealed class CommentEvent {}

class GetCommentsEvent extends CommentEvent {
  GetCommentsEvent({
    this.isRefresh = false,
  });

  final bool isRefresh;
}
