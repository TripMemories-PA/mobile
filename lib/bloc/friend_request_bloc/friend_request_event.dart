part of 'friend_request_bloc.dart';

sealed class FriendRequestEvent {}

class GetFriendRequestEvent extends FriendRequestEvent {
  GetFriendRequestEvent({
    required this.isRefresh,
  });

  final bool isRefresh;
}

class AcceptFriendRequestEvent extends FriendRequestEvent {
  AcceptFriendRequestEvent({
    required this.friendRequestId,
  });

  final String friendRequestId;
}

class RejectFriendRequestEvent extends FriendRequestEvent {
  RejectFriendRequestEvent({
    required this.friendRequestId,
  });

  final String friendRequestId;
}

class DeleteFriendEvent extends FriendRequestEvent {
  DeleteFriendEvent(this.friendId);

  final int friendId;
}
