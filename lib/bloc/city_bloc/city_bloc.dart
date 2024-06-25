import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/city/model/response/cities_response/cities_response.dart';
import '../../object/city/city.dart';
import '../../object/poi/poi.dart';
import '../../object/position.dart';
import '../../object/sort_possibility.dart';
import '../../repository/cities/i_cities_repository.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc({
    required this.citiesRepository,
  }) : super(const CityState()) {
    on<GetCitiesEvent>((event, emit) async {
      if (event.isRefresh) {
        emit(
          state.copyWith(
            searchingCitiesByNameStatus: CityStatus.loading,
            status: CityStatus.loading,
          ),
        );
      } else {
        emit(
          state.copyWith(
            searchingCitiesByNameStatus: CityStatus.loading,
          ),
        );
      }
      final CitiesResponse monuments = await citiesRepository.getCities(
        page: event.isRefresh ? 1 : state.citiesPage + 1,
        perPage: state.citiesPerPage,
        position: event.position,
        sortByName: event.sortByName,
        order: event.order ?? AlphabeticalSortPossibility.ascending,
        searchingCriteria: event.searchingCriteria,
      );
      emit(
        state.copyWith(
          citiesPage: state.isRefresh ? 0 : state.citiesPage + 1,
          cities: event.isRefresh
              ? monuments.data
              : [
                  ...state.cities,
                  ...monuments.data,
                ],
          searchCitiesHasMoreMonuments:
              monuments.data.length == state.citiesPerPage,
          searchingCitiesByNameStatus: CityStatus.notLoading,
          status: CityStatus.notLoading,
        ),
      );
    });
  }

  final int perPage = 10;
  final ICityRepository citiesRepository;
}
