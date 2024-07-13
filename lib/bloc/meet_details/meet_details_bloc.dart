import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/meet/i_meet_service.dart';
import '../../api/meet/model/response/meet_users.dart';
import '../../object/meet.dart';
import '../../object/profile.dart';
import '../../object/ticket.dart';
import '../../repository/meet/i_meet_repository.dart';
import '../../repository/ticket/i_tickets_repository.dart';
import '../meet/meet_bloc.dart';

part 'meet_details_event.dart';
part 'meet_details_state.dart';

class MeetDetailsBloc extends Bloc<MeetDetailsEvent, MeetDetailsState> {
  MeetDetailsBloc({
    required this.meetRepository,
    required this.meetService,
    required this.meetBloc,
    required this.ticketRepository,
  }) : super(MeetDetailsState()) {
    on<GetMeet>((event, emit) async {
      try {
        emit(
          state.copyWith(
            meetDetailsQueryStatus: MeetDetailsQueryStatus.loading,
          ),
        );
        final Meet meet = await meetRepository.getMeet(event.meetId);
        add(GetMeetUsers(isRefresh: true));
        List<Ticket> tickets = [];
        if (meet.ticket == null) {
          tickets = await ticketRepository.getTickets(meet.poi.id);
        }
        emit(
          state.copyWith(
            meet: meet,
            meetDetailsQueryStatus: MeetDetailsQueryStatus.notLoading,
            ticketsToBuy: tickets,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            meetDetailsQueryStatus: MeetDetailsQueryStatus.error,
            error: e is ApiError ? e : ApiError.errorOccurred(),
          ),
        );
      }
    });

    on<LeaveMeetEvent>((event, emit) async {
      emit(state.copyWith(leavingMeetStatus: MeetDetailsQueryStatus.loading));
      try {
        final Meet? meet = state.meet;
        if (meet == null) {
          throw Exception('Meet is null');
        }
        await meetService.leaveMeet(meet.id);
        emit(state.copyWith(leavingMeetStatus: MeetDetailsQueryStatus.left));
        meetBloc.add(GetPoiMeet(poiId: meet.poi.id, isRefresh: true));
      } catch (e) {
        emit(
          state.copyWith(
            leavingMeetStatus: MeetDetailsQueryStatus.error,
            error: e is ApiError ? e : ApiError.errorOccurred(),
          ),
        );
      }
    });

    on<GetMeetUsers>((event, emit) async {
      try {
        if (event.isRefresh) {
          emit(
            state.copyWith(
              getUsersLoadingStatus: MeetDetailsQueryStatus.loading,
            ),
          );
        } else {
          emit(
            state.copyWith(
              getMoreUsersLoadingStatus: MeetDetailsQueryStatus.loading,
            ),
          );
        }
        final MeetUsers response = await meetRepository.getMeetUsers(
          state.meet!.id,
          page: event.isRefresh ? 1 : state.usersPage + 1,
          perPage: state.usersPerPage,
        );
        emit(
          state.copyWith(
            users: event.isRefresh
                ? response.data
                : [...state.users, ...response.data],
            getUsersLoadingStatus: MeetDetailsQueryStatus.notLoading,
            getMoreUsersLoadingStatus: MeetDetailsQueryStatus.notLoading,
            usersPage: event.isRefresh ? 0 : state.usersPage + 1,
            hasMoreUsers:
                response.meta.total > state.users.length + response.data.length,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            getUsersLoadingStatus: MeetDetailsQueryStatus.error,
            error: e is ApiError ? e : ApiError.errorOccurred(),
          ),
        );
      }
    });
  }

  final IMeetRepository meetRepository;
  final IMeetService meetService;
  final ITicketRepository ticketRepository;
  final MeetBloc meetBloc;
}
