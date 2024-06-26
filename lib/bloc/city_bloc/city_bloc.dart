import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/city/model/response/cities_response/cities_response.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../object/city/city.dart';
import '../../object/poi/poi.dart';
import '../../object/position.dart';
import '../../object/sort_possibility.dart';
import '../../repository/city/i_cities_repository.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc({
    required this.cityRepository,
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
      final CitiesResponse monuments = await cityRepository.getCities(
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

    on<GetCityPoiEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedCityGetMonumentsStatus: CityStatus.loading,
        ),
      );
      final PoisResponse pois = await cityRepository.getCityMonuments(
        cityId: event.id,
        page: event.isRefresh ? 1 : state.postCityPage + 1,
        perPage: perPage,
      );
      emit(
        state.copyWith(
          selectedCityGetMonumentsStatus: CityStatus.notLoading,
          selectedCityMonument: event.isRefresh
              ? pois.data
              : [
                  ...state.selectedCityMonument,
                  ...pois.data,
                ],
          getCityHasMoreMonuments: pois.data.length == perPage,
          postCityPage: event.isRefresh ? 0 : state.postCityPage + 1,
        ),
      );
    });
  }

  final int perPage = 10;
  final ICityRepository cityRepository;
}
