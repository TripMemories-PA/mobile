part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  GetProfileEvent(this.userId);

  final String userId;
}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent({
    this.username,
    this.email,
    this.firstName,
    this.lastName,
  });

  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
}

class UpdatePasswordEvent extends ProfileEvent {
  UpdatePasswordEvent(this.password);

  final String password;
}
