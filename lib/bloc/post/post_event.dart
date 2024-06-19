part of 'post_bloc.dart';

sealed class PostEvent {}

class GetMyPostsEvent extends PostEvent {
  GetMyPostsEvent({
    this.isRefresh = false,
  });

  final bool isRefresh;
}

class DeletePostEvent extends PostEvent {
  DeletePostEvent(this.postId);

  final int postId;
}
