part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  GetProfileEvent(this.userId);

  final String userId;
}
