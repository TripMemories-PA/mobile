part of 'publish_post_bloc.dart';

enum EditTweetStatus {
  loading,
  notLoading,
  error,
  posted,
  updated,
}

class PublishPostState {
  const PublishPostState({
    this.status = EditTweetStatus.notLoading,
    this.error,
  });

  PublishPostState copyWith({
    EditTweetStatus? status,
    ApiError? error,
  }) {
    return PublishPostState(
      status: status ?? this.status,
      error: error,
    );
  }

  final EditTweetStatus status;
  final ApiError? error;
}
