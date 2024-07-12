part of 'meet_bloc.dart';

enum MeetQueryStatus { loading, notLoading, error }
enum JoinMeetStatus { loading, notLoading, accepted, rejected }
class MeetState {
  MeetState({
    this.meets = const [],
    this.meetQueryStatus = MeetQueryStatus.notLoading,
    this.currentPage = 0,
    this.hasMoreMeets = true,
    this.getMoreMeetsStatus = MeetQueryStatus.notLoading,
    this.joinMeetStatus = JoinMeetStatus.notLoading,
    this.selectedMeetId,
    this.error,
  });

  MeetState copyWith({
    List<Meet>? meets,
    MeetQueryStatus? meetQueryStatus,
    int? currentPage,
    bool? hasMoreMeets,
    MeetQueryStatus? getMoreMeetsStatus,
    JoinMeetStatus? joinMeetStatus,
    int? selectedMeetId,
    ApiError? error,
  }) {
    return MeetState(
      meets: meets ?? this.meets,
      meetQueryStatus: meetQueryStatus ?? this.meetQueryStatus,
      currentPage: currentPage ?? this.currentPage,
      hasMoreMeets: hasMoreMeets ?? this.hasMoreMeets,
      getMoreMeetsStatus: getMoreMeetsStatus ?? this.getMoreMeetsStatus,
      joinMeetStatus: joinMeetStatus ?? this.joinMeetStatus,
      selectedMeetId: selectedMeetId,
      error: error,
    );
  }

  List<Meet> meets;
  MeetQueryStatus meetQueryStatus;
  int currentPage;
  int perPage = 10;
  bool hasMoreMeets;
  MeetQueryStatus getMoreMeetsStatus;
  JoinMeetStatus joinMeetStatus;
  int? selectedMeetId;
  ApiError? error;

}
