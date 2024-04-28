part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  GetProfileEvent(this.userId);

  final String userId;
}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent({
    this.userName,
    this.lastName,
    this.firstName,
    this.email,
  });

  final String? userName;
  final String? lastName;
  final String? firstName;
  final String? email;
}

class UpdatePasswordEvent extends ProfileEvent {
  UpdatePasswordEvent(this.password);

  final String password;
}
