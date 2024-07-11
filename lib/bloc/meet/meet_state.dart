part of 'meet_bloc.dart';

enum MeetQueryStatus { loading, notLoading, error }

class MeetState {
  MeetState({
    this.meets = const [],
    this.meetQueryStatus = MeetQueryStatus.notLoading,
    this.currentPage = 0,
    this.hasMoreMeets = true,
    this.getMoreMeetsStatus = MeetQueryStatus.notLoading,
  });

  MeetState copyWith({
    List<Meet>? meets,
    MeetQueryStatus? meetQueryStatus,
    int? currentPage,
    bool? hasMoreMeets,
    MeetQueryStatus? getMoreMeetsStatus,
  }) {
    return MeetState(
      meets: meets ?? this.meets,
      meetQueryStatus: meetQueryStatus ?? this.meetQueryStatus,
      currentPage: currentPage ?? this.currentPage,
      hasMoreMeets: hasMoreMeets ?? this.hasMoreMeets,
      getMoreMeetsStatus: getMoreMeetsStatus ?? this.getMoreMeetsStatus,
    );
  }

  List<Meet> meets;
  MeetQueryStatus meetQueryStatus;
  int currentPage;
  int perPage = 10;
  bool hasMoreMeets;
  MeetQueryStatus getMoreMeetsStatus;

}
