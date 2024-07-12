part of 'meet_details_bloc.dart';

sealed class MeetDetailsEvent {}

class GetMeet extends MeetDetailsEvent {
  GetMeet({required this.meetId});

  final int meetId;
}
