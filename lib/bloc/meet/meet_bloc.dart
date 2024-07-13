import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/meet/i_meet_service.dart';
import '../../api/meet/model/query/create_meet_query.dart';
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
      try {
        if (event.isRefresh) {
          emit(state.copyWith(meetQueryStatus: MeetQueryStatus.loading));
        } else {
          emit(state.copyWith(getMoreMeetsStatus: MeetQueryStatus.loading));
        }
        final MeetResponse response = await meetRepository.getPoiMeet(
          poiId: event.poiId,
          page: event.isRefresh ? 1 : state.currentPage + 1,
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
            currentPage: event.isRefresh ? 1 : state.currentPage + 1,
            hasMoreMeets: state.perPage == newMeets.length,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            meetQueryStatus: MeetQueryStatus.error,
            getMoreMeetsStatus: MeetQueryStatus.error,
            error: e is ApiError ? e : ApiError.errorOccurred(),
          ),
        );
      }
      emit(
        state.copyWith(
          meetQueryStatus: MeetQueryStatus.notLoading,
          getMoreMeetsStatus: MeetQueryStatus.notLoading,
        ),
      );
    });

    on<AskToJoinMeet>((event, emit) async {
      try {
        emit(
          state.copyWith(
            joinMeetStatus: JoinMeetStatus.loading,
            selectedMeetId: event.meetId,
          ),
        );
        await meetService.joinMeet(
          event.meetId,
        );
        emit(
          state.copyWith(
            joinMeetStatus: JoinMeetStatus.accepted,
            meets: state.meets.map((meet) {
              if (meet.id == event.meetId) {
                return meet.copyWith(
                  canJoin: false,
                  hasJoined: true,
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
      emit(
        state.copyWith(
          joinMeetStatus: JoinMeetStatus.notLoading,
        ),
      );
    });

    on<PostMeetFromPoiPage>((event, emit) async {
      try {
        emit(state.copyWith(postMeetStatus: PostMeetStatus.loading));
        await meetService.createMeet(event.query);
        emit(state.copyWith(postMeetStatus: PostMeetStatus.posted));
        add(GetPoiMeet(poiId: event.poiId, isRefresh: true));
      } catch (e) {
        emit(
          state.copyWith(
            postMeetStatus: PostMeetStatus.error,
            error: e is ApiError ? e : ApiError.errorOccurred(),
          ),
        );
        emit(
          state.copyWith(
            postMeetStatus: PostMeetStatus.notLoading,
          ),
        );
      }
    });

    on<DeleteMeet>((event, emit) async {
      try {
        await meetService.deleteMeet(event.meetId);
        List<Meet> newMeets = [];
        for (int i = 0; i < state.meets.length; i++) {
          if (state.meets[i].id != event.meetId) {
            newMeets.add(state.meets[i]);
          }
        }
        emit(
          state.copyWith(
            meets: newMeets,
            deleteMeetStatus: DeleteMeetStatus.deleted,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            error: e is ApiError ? e : ApiError.errorOccurred(),
          ),
        );
      }
      emit(
        state.copyWith(
          deleteMeetStatus: DeleteMeetStatus.notLoading,
        ),
      );
    });
  }

  final IMeetRepository meetRepository;
  final IMeetService meetService;
}
