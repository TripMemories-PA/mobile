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

class SearchUsersEvent extends UserSearchingEvent {
  SearchUsersEvent({
    required this.searchingCriteria,
    required this.isRefresh,
  });

  final String searchingCriteria;
  final bool isRefresh;
}

class GetUsersRanking extends UserSearchingEvent {
  GetUsersRanking({
    required this.isRefresh,
  });

  final bool isRefresh;
}
