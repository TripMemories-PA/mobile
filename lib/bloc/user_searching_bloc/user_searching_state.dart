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
    this.searchingUserByNameStatus = UserSearchingStatus.notLoading,
    this.usersSearchByName,
    this.searchUsersError,
    this.searchUsersPerPage = 10,
    this.searchUsersPage = 0,
    this.searchUsersHasMoreUsers = true,
    this.searchUsersIsRefresh = false,
  });

  UserSearchingState copyWith({
    GetFriendsPaginationResponse? users,
    UserSearchingStatus? status,
    ApiError? error,
    GetFriendsPaginationResponse? friends,
    int? friendsPage,
    bool? hasMoreUsers,
    UserSearchingStatus? searchingUserByNameStatus,
    GetFriendsPaginationResponse? usersSearchByName,
    int? searchUsersPerPage,
    int? searchUsersPage,
    bool? searchUsersHasMoreUsers,
    bool? searchUsersIsRefresh,
    ApiError? searchUsersError,
  }) {
    return UserSearchingState(
      users: users ?? this.users,
      status: status ?? this.status,
      error: error,
      friendsPage: friendsPage ?? this.friendsPage,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
      searchingUserByNameStatus:
          searchingUserByNameStatus ?? this.searchingUserByNameStatus,
      usersSearchByName: usersSearchByName ?? this.usersSearchByName,
      searchUsersPerPage: searchUsersPerPage ?? this.searchUsersPerPage,
      searchUsersPage: searchUsersPage ?? this.searchUsersPage,
      searchUsersHasMoreUsers:
          searchUsersHasMoreUsers ?? this.searchUsersHasMoreUsers,
      searchUsersIsRefresh: searchUsersIsRefresh ?? this.searchUsersIsRefresh,
      searchUsersError: searchUsersError,
    );
  }

  final GetFriendsPaginationResponse? users;
  final UserSearchingStatus status;
  final ApiError? error;
  final int friendsPerPage;
  final int friendsPage;
  final bool hasMoreUsers;
  final bool isRefresh;
  final UserSearchingStatus searchingUserByNameStatus;
  final GetFriendsPaginationResponse? usersSearchByName;
  final int searchUsersPerPage;
  final int searchUsersPage;
  final bool searchUsersHasMoreUsers;
  final bool searchUsersIsRefresh;
  final ApiError? searchUsersError;
}
