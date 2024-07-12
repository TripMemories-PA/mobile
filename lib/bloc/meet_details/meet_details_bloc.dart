import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/meet/i_meet_service.dart';
import '../../object/meet.dart';
import '../../repository/meet/i_meet_repository.dart';
import '../meet/meet_bloc.dart';

part 'meet_details_event.dart';
part 'meet_details_state.dart';

class MeetDetailsBloc extends Bloc<MeetDetailsEvent, MeetDetailsState> {
  MeetDetailsBloc({
    required this.meetRepository,
    required this.meetService,
    required this.meetBloc,
  }) : super(MeetDetailsState()) {
    on<GetMeet>((event, emit) async {
      emit(
        state.copyWith(meetDetailsQueryStatus: MeetDetailsQueryStatus.loading),
      );
      final Meet meet = await meetRepository.getMeet(event.meetId);
      emit(
        state.copyWith(
          meet: meet,
          meetDetailsQueryStatus: MeetDetailsQueryStatus.notLoading,
        ),
      );
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
  }

  final IMeetRepository meetRepository;
  final IMeetService meetService;
  final MeetBloc meetBloc;
}
