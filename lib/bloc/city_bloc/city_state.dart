part of 'city_bloc.dart';

enum CityStatus { loading, notLoading, error }

class CityState {
  const CityState({
    this.cities = const [],
    this.citiesPerPage = 10,
    this.citiesPage = 0,
    this.status = CityStatus.notLoading,
    this.searchingCitiesByNameStatus = CityStatus.notLoading,
    this.searchCitiesHasMoreMonuments = true,
    this.isRefresh = false,
    this.selectedCityMonument = const [],
    this.monumentsCityPage = 0,
    this.selectedCityGetMonumentsStatus = CityStatus.notLoading,
    this.getCityHasMoreMonuments = true,
  });

  CityState copyWith({
    List<City>? cities,
    int? citiesPerPage,
    int? citiesPage,
    CityStatus? status,
    CityStatus? searchingCitiesByNameStatus,
    bool? searchCitiesHasMoreMonuments,
    bool? isRefresh,
    City? selectedCity,
    List<Poi>? selectedCityMonument,
    int? monumentsCityPage,
    CityStatus? selectedCityGetMonumentsStatus,
    bool? getCityHasMoreMonuments,
  }) {
    return CityState(
      cities: cities ?? this.cities,
      citiesPerPage: citiesPerPage ?? this.citiesPerPage,
      citiesPage: citiesPage ?? this.citiesPage,
      status: status ?? this.status,
      searchingCitiesByNameStatus:
          searchingCitiesByNameStatus ?? this.searchingCitiesByNameStatus,
      searchCitiesHasMoreMonuments:
          searchCitiesHasMoreMonuments ?? this.searchCitiesHasMoreMonuments,
      isRefresh: isRefresh ?? this.isRefresh,
      selectedCityMonument: selectedCityMonument ?? this.selectedCityMonument,
      monumentsCityPage: monumentsCityPage ?? this.monumentsCityPage,
      selectedCityGetMonumentsStatus:
          selectedCityGetMonumentsStatus ?? this.selectedCityGetMonumentsStatus,
      getCityHasMoreMonuments:
          getCityHasMoreMonuments ?? this.getCityHasMoreMonuments,
    );
  }

  final List<City> cities;
  final int citiesPerPage;
  final int citiesPage;
  final CityStatus status;
  final CityStatus searchingCitiesByNameStatus;
  final bool searchCitiesHasMoreMonuments;
  final bool isRefresh;
  final List<Poi> selectedCityMonument;
  final int monumentsCityPage;
  final CityStatus selectedCityGetMonumentsStatus;
  final bool getCityHasMoreMonuments;
}
