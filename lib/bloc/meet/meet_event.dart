part of 'meet_bloc.dart';

sealed class MeetEvent {}

class GetPoiMeet extends MeetEvent {
  GetPoiMeet({required this.poiId, this.isRefresh = false});

  final int poiId;
  final bool isRefresh;
}
