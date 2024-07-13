part of 'meet_details_bloc.dart';

enum MeetDetailsQueryStatus { loading, notLoading, error, left }

class MeetDetailsState {
  MeetDetailsState({
    this.meet,
    this.meetDetailsQueryStatus = MeetDetailsQueryStatus.notLoading,
    this.leavingMeetStatus = MeetDetailsQueryStatus.notLoading,
    this.error,
    this.users = const [],
    this.usersPage = 0,
    this.usersPerPage = 10,
    this.hasMoreUsers = true,
    this.getUsersLoadingStatus = MeetDetailsQueryStatus.notLoading,
    this.getMoreUsersLoadingStatus = MeetDetailsQueryStatus.notLoading,
    this.ticketsToBuy = const [],
  });

  MeetDetailsState copyWith({
    Meet? meet,
    MeetDetailsQueryStatus? meetDetailsQueryStatus,
    MeetDetailsQueryStatus? leavingMeetStatus,
    ApiError? error,
    List<Profile>? users,
    int? usersPage,
    int? usersPerPage,
    bool? hasMoreUsers,
    MeetDetailsQueryStatus? getUsersLoadingStatus,
    MeetDetailsQueryStatus? getMoreUsersLoadingStatus,
    List<Ticket>? ticketsToBuy,
  }) {
    return MeetDetailsState(
      meet: meet ?? this.meet,
      meetDetailsQueryStatus:
          meetDetailsQueryStatus ?? this.meetDetailsQueryStatus,
      leavingMeetStatus: leavingMeetStatus ?? this.leavingMeetStatus,
      error: error,
      users: users ?? this.users,
      usersPage: usersPage ?? this.usersPage,
      usersPerPage: usersPerPage ?? this.usersPerPage,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
      getUsersLoadingStatus:
          getUsersLoadingStatus ?? this.getUsersLoadingStatus,
      getMoreUsersLoadingStatus:
          getMoreUsersLoadingStatus ?? this.getMoreUsersLoadingStatus,
      ticketsToBuy: ticketsToBuy ?? this.ticketsToBuy,
    );
  }

  Meet? meet;
  List<Ticket> ticketsToBuy;
  MeetDetailsQueryStatus meetDetailsQueryStatus;
  MeetDetailsQueryStatus leavingMeetStatus;
  ApiError? error;
  List<Profile> users;
  int usersPage;
  int usersPerPage;
  bool hasMoreUsers;
  MeetDetailsQueryStatus getUsersLoadingStatus;
  MeetDetailsQueryStatus getMoreUsersLoadingStatus;
}
