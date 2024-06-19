part of 'publish_post_bloc.dart';

sealed class PublishPostEvent {}

class PostTweetRequested extends PublishPostEvent {
  PostTweetRequested({
    required this.monumentId,
    required this.content,
    required this.rating,
    this.image,
  });

  final int monumentId;
  final String content;
  final double rating;
  final XFile? image;
}
