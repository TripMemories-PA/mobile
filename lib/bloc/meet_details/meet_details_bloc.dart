import 'package:flutter_bloc/flutter_bloc.dart';

import '../../object/meet.dart';
import '../../repository/meet/i_meet_repository.dart';

part 'meet_details_event.dart';
part 'meet_details_state.dart';

class MeetDetailsBloc extends Bloc<MeetDetailsEvent, MeetDetailsState> {
  MeetDetailsBloc({required this.meetRepository}) : super(MeetDetailsState()) {
    on<GetMeet>((event, emit) async {
      emit(state.copyWith(meetDetailsQueryStatus: MeetDetailsQueryStatus.loading));
      final Meet meet = await meetRepository.getMeet(event.meetId);
      emit(
        state.copyWith(
          meet: meet,
          meetDetailsQueryStatus: MeetDetailsQueryStatus.notLoading,
        ),
      );
    });
  }

  final IMeetRepository meetRepository;
}
