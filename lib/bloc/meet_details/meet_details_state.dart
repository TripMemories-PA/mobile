part of 'meet_details_bloc.dart';

enum MeetDetailsQueryStatus { loading, notLoading, error, left }

class MeetDetailsState {
  MeetDetailsState({
    this.meet,
    this.meetDetailsQueryStatus = MeetDetailsQueryStatus.notLoading,
    this.leavingMeetStatus = MeetDetailsQueryStatus.notLoading,
    this.error,
  });

  MeetDetailsState copyWith({
    Meet? meet,
    MeetDetailsQueryStatus? meetDetailsQueryStatus,
    MeetDetailsQueryStatus? leavingMeetStatus,
    ApiError? error,
  }) {
    return MeetDetailsState(
      meet: meet ?? this.meet,
      meetDetailsQueryStatus:
          meetDetailsQueryStatus ?? this.meetDetailsQueryStatus,
      leavingMeetStatus: leavingMeetStatus ?? this.leavingMeetStatus,
      error: error,
    );
  }

  Meet? meet;
  MeetDetailsQueryStatus meetDetailsQueryStatus;
  MeetDetailsQueryStatus leavingMeetStatus;
  ApiError? error;
}
