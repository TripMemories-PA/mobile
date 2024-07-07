part of 'city_bloc.dart';

sealed class CityEvent {}

class GetCitiesEvent extends CityEvent {
  GetCitiesEvent({
    this.position,
    this.sortByName = true,
    this.order = AlphabeticalSortPossibility.ascending,
    this.isRefresh = false,
    this.searchingCriteria,
  });

  final PositionDataCustom? position;
  final bool sortByName;
  final AlphabeticalSortPossibility? order;

  //isRefresh pour le moment où la recherche par monument change de filtre
  final bool isRefresh;
  final String? searchingCriteria;
}

class GetCityEvent extends CityEvent {
  GetCityEvent({
    required this.id,
  });

  final int id;
}

class GetCityPoiEvent extends CityEvent {
  GetCityPoiEvent({
    required this.id,
    this.isRefresh = false,
  });

  final int id;
  final bool isRefresh;
}
