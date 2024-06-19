part of 'post_bloc.dart';

sealed class PostEvent {}

class GetPostsEvent extends PostEvent {
  GetPostsEvent({
    this.isRefresh = false,
    this.userId,
  });

  final bool isRefresh;
  final int? userId;
}

class DeletePostEvent extends PostEvent {
  DeletePostEvent(this.postId);

  final int postId;
}

class LikePostEvent extends PostEvent {
  LikePostEvent(this.postId);

  final int postId;
}

class DislikePostEvent extends PostEvent {
  DislikePostEvent(this.postId);

  final int postId;
}
