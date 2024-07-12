part of 'meet_details_bloc.dart';

enum MeetDetailsQueryStatus { loading, notLoading, error }

class MeetDetailsState {
  MeetDetailsState({
    this.meet,
    this.meetDetailsQueryStatus = MeetDetailsQueryStatus.notLoading,
  });

  MeetDetailsState copyWith({
    Meet? meet,
    MeetDetailsQueryStatus? meetDetailsQueryStatus,
  }) {
    return MeetDetailsState(
      meet: meet ?? this.meet,
      meetDetailsQueryStatus: meetDetailsQueryStatus ?? this.meetDetailsQueryStatus,
    );
  }

  Meet? meet;
  MeetDetailsQueryStatus meetDetailsQueryStatus;
}
