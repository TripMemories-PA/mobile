part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  notLoading,
  error,
}

class ProfileState {
  const ProfileState({
    this.profile,
    this.status = ProfileStatus.initial,
    this.error,
    this.friends,
  });

  ProfileState copyWith({
    Profile? profile,
    ProfileStatus? status,
    ApiError? error,
    GetFriendsPaginationResponse? friends,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      error: error,
      friends: friends ?? this.friends,
    );
  }

  final Profile? profile;
  final ProfileStatus status;
  final ApiError? error;
  final GetFriendsPaginationResponse? friends;
}
