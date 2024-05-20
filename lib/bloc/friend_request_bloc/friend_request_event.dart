part of 'friend_request_bloc.dart';

sealed class FriendRequestEvent {}

class GetFriendRequestEvent extends FriendRequestEvent {
  GetFriendRequestEvent({
    required this.isRefresh,
  });

  final bool isRefresh;
}
