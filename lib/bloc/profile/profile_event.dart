part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  GetProfileEvent(this.userId);

  final String userId;
}
