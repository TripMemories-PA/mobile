part of 'profile_bloc.dart';

class ProfileState {
  const ProfileState({
    this.profile,
  });

  ProfileState copyWith({
    Profile? profile,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
    );
  }

  final Profile? profile;
}
