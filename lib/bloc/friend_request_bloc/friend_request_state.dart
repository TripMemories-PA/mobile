part of 'friend_request_bloc.dart';

enum FriendRequestStatus {
  loading,
  notLoading,
  accepted,
  refused,
  error,
  friendShipDeleted,
}

class FriendRequestState {
  const FriendRequestState({
    this.friendRequests,
    this.status = FriendRequestStatus.notLoading,
    this.error,
    this.friendsPerPage = 30,
    this.friendsPage = 0,
    this.hasMoreTweets = true,
    this.isRefresh = false,
  });

  FriendRequestState copyWith({
    GetFriendRequestResponse? friendRequests,
    FriendRequestStatus? status,
    ApiError? error,
    GetFriendsPaginationResponse? friends,
    int? friendsPage,
    bool? hasMoreTweets,
  }) {
    return FriendRequestState(
      friendRequests: friendRequests ?? this.friendRequests,
      status: status ?? this.status,
      error: error,
      friendsPage: friendsPage ?? this.friendsPage,
      hasMoreTweets: hasMoreTweets ?? this.hasMoreTweets,
    );
  }

  final GetFriendRequestResponse? friendRequests;
  final FriendRequestStatus status;
  final ApiError? error;
  final int friendsPerPage;
  final int friendsPage;
  final bool hasMoreTweets;
  final bool isRefresh;
}
