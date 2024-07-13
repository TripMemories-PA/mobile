part of 'meet_details_bloc.dart';

sealed class MeetDetailsEvent {}

class GetMeet extends MeetDetailsEvent {
  GetMeet({required this.meetId});

  final int meetId;
}

class LeaveMeetEvent extends MeetDetailsEvent {}

class GetMeetUsers extends MeetDetailsEvent {
  GetMeetUsers({this.isRefresh = false, required this.meetId});

  final bool isRefresh;
  final int meetId;
}

class KickUser extends MeetDetailsEvent {
  KickUser({required this.userId, required this.meetId});

  final int userId;
  final int meetId;
}
