part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  GetProfileEvent({this.userId});

  int? userId;
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
    this.isRefresh = false,
    this.position,
    this.radius,
    this.isOnMap = false,
  });

  final bool isRefresh;
  final PositionDataCustom? position;
  final RadiusQueryInfos? radius;
  final bool isOnMap;
}

class UpdateProfilePictureEvent extends ProfileEvent {
  UpdateProfilePictureEvent(this.image);

  final XFile image;
}

class UpdateProfileBannerEvent extends ProfileEvent {
  UpdateProfileBannerEvent(this.image);

  final XFile image;
}
