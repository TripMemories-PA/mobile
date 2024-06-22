part of 'monument_bloc.dart';

sealed class MonumentEvent {}

class GetMonumentsEvent extends MonumentEvent {
  GetMonumentsEvent({
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

class GetMonumentsOnMapEvent extends MonumentEvent {
  GetMonumentsOnMapEvent({
    this.position,
    this.radius,
    this.isRefresh = false,
  });

  final Position? position;
  final RadiusQueryInfos? radius;
  final bool isRefresh;
}

class GetMonumentEvent extends MonumentEvent {
  GetMonumentEvent({
    required this.id,
  });

  final int id;
}
