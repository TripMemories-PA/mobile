import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/meet/model/response/meet_response.dart';
import '../../object/meet.dart';
import '../../repository/meet/i_meet_repository.dart';

part 'meet_event.dart';
part 'meet_state.dart';

class MeetBloc extends Bloc<MeetEvent, MeetState> {
  MeetBloc({required this.meetRepository}) : super(MeetState()) {
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
      emit(
        state.copyWith(
          meets: event.isRefresh ? response.data : List.of(state.meets)
            ..addAll(response.data),
          meetQueryStatus: MeetQueryStatus.notLoading,
          getMoreMeetsStatus: MeetQueryStatus.notLoading,
          currentPage: event.isRefresh ? 0 : state.currentPage + 1,
          hasMoreMeets: response.meta.total == state.meets.length + response.data.length,
        ),
      );
    });
  }

  final IMeetRepository meetRepository;
}
