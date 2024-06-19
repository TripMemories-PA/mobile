import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/monument/model/response/poi/poi.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../object/position.dart';
import '../../object/sort_possibility.dart';
import '../../repository/monument_repository.dart';

part 'monument_event.dart';
part 'monument_state.dart';

class MonumentBloc extends Bloc<MonumentEvent, MonumentState> {
  MonumentBloc({
    required MonumentRepository monumentRepository,
  }) : super(const MonumentState()) {
    on<GetMonumentsEvent>((event, emit) async {
      emit(
        state.copyWith(
          searchingMonumentByNameStatus: MonumentStatus.loading,
        ),
      );
      final PoisResponse monuments = await monumentRepository.getMonuments(
        page: 1,
        perPage: 50,
        position: Position(
          swLat: 1,
          swLng: 1,
          neLat: 1,
          neLng: 1,
        ),
        sortByName: true,
        order: AlphabeticalSortPossibility.ascending,
        searchingCriteria: event.searchingCriteria,
      );
      emit(
        state.copyWith(
          monuments: monuments.data,
          searchingMonumentByNameStatus: MonumentStatus.notLoading,
        ),
      );
    });

    on<GetMonumentsOnMapEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: MonumentStatus.loading,
        ),
      );
      final PoisResponse monuments = await monumentRepository.getMonuments(
        page: 1,
        perPage: 50,
        position: event.position,
        sortByName: true,
        order: AlphabeticalSortPossibility.ascending,
      );
      emit(
        state.copyWith(
          monuments: monuments.data,
          status: MonumentStatus.notLoading,
        ),
      );
    });
  }
}
