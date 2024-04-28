part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  GetProfileEvent(this.userId);

  final String userId;
}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent(this.profile);

  final Profile profile;
}

class UpdatePasswordEvent extends ProfileEvent {
  UpdatePasswordEvent(this.password);

  final String password;
}
