part of 'user_searching_bloc.dart';

enum UserSearchingStatus {
  loading,
  notLoading,
  error,
  requestSent,
}

class UserSearchingState {
  const UserSearchingState({
    this.users,
    this.status = UserSearchingStatus.notLoading,
    this.error,
    this.friendsPerPage = 10,
    this.friendsPage = 0,
    this.hasMoreUsers = true,
    this.isRefresh = false,
  });

  UserSearchingState copyWith({
    GetFriendsPaginationResponse? users,
    UserSearchingStatus? status,
    ApiError? error,
    GetFriendsPaginationResponse? friends,
    int? friendsPage,
    bool? hasMoreUsers,
  }) {
    return UserSearchingState(
      users: users ?? this.users,
      status: status ?? this.status,
      error: error,
      friendsPage: friendsPage ?? this.friendsPage,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
    );
  }

  final GetFriendsPaginationResponse? users;
  final UserSearchingStatus status;
  final ApiError? error;
  final int friendsPerPage;
  final int friendsPage;
  final bool hasMoreUsers;
  final bool isRefresh;
}
