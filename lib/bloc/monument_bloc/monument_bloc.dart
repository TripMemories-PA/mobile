import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/monument/model/response/poi/poi.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../object/position.dart';
import '../../object/sort_possibility.dart';
import '../../repository/monument/i_monument_repository.dart';

part 'monument_event.dart';
part 'monument_state.dart';

class MonumentBloc extends Bloc<MonumentEvent, MonumentState> {
  MonumentBloc({
    required this.monumentRepository,
  }) : super(const MonumentState()) {
    on<GetMonumentsEvent>((event, emit) async {
      if (event.isRefresh) {
        emit(
          state.copyWith(
            searchingMonumentByNameStatus: MonumentStatus.loading,
          ),
        );
      } else {
        emit(
          state.copyWith(
            searchingMonumentByNameStatus: MonumentStatus.loading,
          ),
        );
      }
      final PoisResponse monuments = await monumentRepository.getMonuments(
        page: event.isRefresh ? 1 : state.monumentsPage + 1,
        perPage: state.monumentsPerPage,
        position: event.position,
        sortByName: event.sortByName,
        order: event.order ?? AlphabeticalSortPossibility.ascending,
        searchingCriteria: event.searchingCriteria,
      );
      emit(
        state.copyWith(
          monumentsPage: state.isRefresh ? 0 : state.monumentsPage + 1,
          monuments: event.isRefresh
              ? monuments.data
              : [
                  ...state.monuments,
                  ...monuments.data,
                ],
          searchMonumentsHasMoreMonuments:
              monuments.data.length == state.monumentsPerPage,
          searchingMonumentByNameStatus: MonumentStatus.notLoading,
          status: MonumentStatus.notLoading,
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

  final IMonumentRepository monumentRepository;
}
