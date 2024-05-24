part of 'user_searching_bloc.dart';

sealed class UserSearchingEvent {}

class GetUsersRequestEvent extends UserSearchingEvent {
  GetUsersRequestEvent({
    required this.isRefresh,
  });

  final bool isRefresh;
}

class SendFriendRequestEvent extends UserSearchingEvent {
  SendFriendRequestEvent({
    required this.userId,
  });

  final String userId;
}
