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
  });

  ProfileState copyWith({
    Profile? profile,
    ProfileStatus? status,
    ApiError? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      error: error,
    );
  }

  final Profile? profile;
  final ProfileStatus status;
  final ApiError? error;
}
