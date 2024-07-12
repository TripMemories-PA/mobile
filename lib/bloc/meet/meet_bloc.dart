import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/meet/i_meet_service.dart';
import '../../api/meet/model/response/meet_response.dart';
import '../../api/meet/model/response/meet_users.dart';
import '../../object/meet.dart';
import '../../repository/meet/i_meet_repository.dart';

part 'meet_event.dart';
part 'meet_state.dart';

class MeetBloc extends Bloc<MeetEvent, MeetState> {
  MeetBloc({required this.meetRepository, required this.meetService})
      : super(MeetState()) {
    on<GetPoiMeet>((event, emit) async {
      if (event.isRefresh) {
        emit(state.copyWith(meetQueryStatus: MeetQueryStatus.loading));
      } else {
        emit(state.copyWith(getMoreMeetsStatus: MeetQueryStatus.loading));
      }
      final MeetResponse response = await meetRepository.getPoiMeet(
        poiId: event.poiId,
        page: state.currentPage + 1,
        perPage: state.perPage,
      );
      final List<Meet> newMeets = [];
      for (int i = 0; i < response.data.length; i++) {
        final MeetUsers meetUsers = await meetRepository.getMeetUsers(
          response.data[i].id,
          page: 1,
          perPage: 3,
        );
        newMeets.add(response.data[i].copyWith(users: meetUsers.data));
      }
      emit(
        state.copyWith(
          meets: event.isRefresh ? newMeets : [...state.meets, ...newMeets],
          meetQueryStatus: MeetQueryStatus.notLoading,
          getMoreMeetsStatus: MeetQueryStatus.notLoading,
          currentPage: event.isRefresh ? 0 : state.currentPage + 1,
          hasMoreMeets:
              response.meta.total == state.meets.length + newMeets.length,
        ),
      );
    });

    on<AskToJoinMeet>((event, emit) async {
      try {
        emit(state.copyWith(joinMeetStatus: JoinMeetStatus.loading));
        await meetService.joinMeet(
          event.meetId,
        );
        emit(
          state.copyWith(
            joinMeetStatus: JoinMeetStatus.accepted,
            meets: state.meets.map((meet) {
              if (meet.id == event.meetId) {
                return meet.copyWith(
                  canJoin: true,
                );
              }
              return meet;
            }).toList(),
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            joinMeetStatus: JoinMeetStatus.rejected,
          ),
        );
      }
    });
  }

  final IMeetRepository meetRepository;
  final IMeetService meetService;
}
