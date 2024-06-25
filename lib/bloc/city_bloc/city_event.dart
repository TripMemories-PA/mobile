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

  final Position? position;
  final bool sortByName;
  final AlphabeticalSortPossibility? order;

  //isRefresh pour le moment où la recherche par monument change de filtre
  final bool isRefresh;
  final String? searchingCriteria;
}
