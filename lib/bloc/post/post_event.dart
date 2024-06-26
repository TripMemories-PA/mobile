part of 'post_bloc.dart';

sealed class PostEvent {}

class GetPostsEvent extends PostEvent {
  GetPostsEvent({
    this.isRefresh = false,
    this.userId,
    this.myPosts = false,
  });

  final bool myPosts;
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

class IncrementCommentCounterEvent extends PostEvent {
  IncrementCommentCounterEvent(this.postId);

  final int postId;
}

class DecrementCommentCounterEvent extends PostEvent {
  DecrementCommentCounterEvent(this.postId);

  final int postId;
}

class IncrementLikeCounterEvent extends PostEvent {
  IncrementLikeCounterEvent(this.postId);

  final int postId;
}

class DecrementLikeCounterEvent extends PostEvent {
  DecrementLikeCounterEvent(this.postId);

  final int postId;
}
