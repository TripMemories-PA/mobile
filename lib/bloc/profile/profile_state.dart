part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  notLoading,
  updated,
  error,
  postDeleted,
}

class ProfileState {
  const ProfileState({
    this.profile,
    this.status = ProfileStatus.initial,
    this.error,
    this.friends,
    this.friendsPerPage = 10,
    this.friendsPage = 0,
    this.hasMoreFriends = true,
    this.getMoreFriendsStatus = ProfileStatus.initial,
  });

  ProfileState copyWith({
    Profile? profile,
    ProfileStatus? status,
    ProfileStatus? getMorePostsStatus,
    ApiError? error,
    GetFriendsPaginationResponse? friends,
    int? friendsPage,
    bool? hasMoreFriends,
    ProfileStatus? getMoreFriendsStatus,
    GetAllPostsResponse? posts,
    int? postsPage,
    int? postsPerPage,
    bool? hasMorePosts,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      error: error,
      friends: friends ?? this.friends,
      friendsPage: friendsPage ?? this.friendsPage,
      hasMoreFriends: hasMoreFriends ?? this.hasMoreFriends,
      getMoreFriendsStatus: getMoreFriendsStatus ?? this.getMoreFriendsStatus,
    );
  }

  final Profile? profile;
  final ProfileStatus status;
  final ProfileStatus getMoreFriendsStatus;
  final ApiError? error;
  final GetFriendsPaginationResponse? friends;
  final int friendsPerPage;
  final int friendsPage;
  final bool hasMoreFriends;
}
