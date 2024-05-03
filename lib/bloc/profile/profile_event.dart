part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  GetProfileEvent();
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

class GetFriendsEvent extends ProfileEvent {
  GetFriendsEvent({
    required this.page,
    required this.perPage,
  });

  final int page;
  final int perPage;
}

class UpdateProfilePictureEvent extends ProfileEvent {
  UpdateProfilePictureEvent(this.image);

  final XFile image;
}
