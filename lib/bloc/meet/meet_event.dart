part of 'meet_bloc.dart';

sealed class MeetEvent {}

class GetPoiMeet extends MeetEvent {
  GetPoiMeet({required this.poiId, this.isRefresh = false});

  final int poiId;
  final bool isRefresh;
}

class AskToJoinMeet extends MeetEvent {
  AskToJoinMeet({required this.meetId});

  final int meetId;
}

class PostMeetFromPoiPage extends MeetEvent {
  PostMeetFromPoiPage({required this.query, required this.poiId});

  final CreateMeetQuery query;
  final int poiId;
}

class DeleteMeet extends MeetEvent {
  DeleteMeet({required this.meetId});

  final int meetId;
}

class UpdateMeet extends MeetEvent {
  UpdateMeet({required this.query});

  final UpdateMeetQuery query;
}
