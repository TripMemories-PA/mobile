import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/monument/model/response/poi/poi.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
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
      int page = 1;
      final PoisResponse monuments = await monumentRepository.getMonuments(
        page: page,
        perPage: 10,
        position: event.position,
        radius: event.radius,
        sortByName: true,
        order: AlphabeticalSortPossibility.ascending,
      );
      if (!event.isRefresh) {
        int cpt = 0;
        final List<Poi> newMonuments = [];
        while (newMonuments.length < perPage) {
          page++;
          final PoisResponse monuments = await monumentRepository.getMonuments(
            page: page,
            perPage: 10,
            position: event.position,
            radius: event.radius,
            sortByName: true,
            order: AlphabeticalSortPossibility.ascending,
          );
          for (final Poi poi in monuments.data) {
            if (state.monuments.contains(poi)) {
              cpt++;
            } else {
              newMonuments.add(poi);
            }
          }
          if (monuments.data.length < perPage || cpt == monuments.data.length) {
            break;
          }
        }
      }
      emit(
        state.copyWith(
          monuments: monuments.data,
          status: MonumentStatus.notLoading,
        ),
      );
    });
  }
  final int perPage = 10;
  final IMonumentRepository monumentRepository;
}
