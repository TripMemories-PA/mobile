part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  notLoading,
  updated,
  error,
}

class ProfileState {
  const ProfileState({
    this.profile,
    this.status = ProfileStatus.initial,
    this.error,
    this.friends,
    this.friendsPerPage = 10,
    this.friendsPage = 0,
    this.hasMoreTweets = true,
  });

  ProfileState copyWith({
    Profile? profile,
    ProfileStatus? status,
    ApiError? error,
    GetFriendsPaginationResponse? friends,
    int? friendsPage,
    bool? hasMoreTweets,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      error: error,
      friends: friends ?? this.friends,
      friendsPage: friendsPage ?? this.friendsPage,
      hasMoreTweets: hasMoreTweets ?? this.hasMoreTweets,
    );
  }

  final Profile? profile;
  final ProfileStatus status;
  final ApiError? error;
  final GetFriendsPaginationResponse? friends;
  final int friendsPerPage;
  final int friendsPage;
  final bool hasMoreTweets;
}
