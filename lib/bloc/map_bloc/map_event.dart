part of 'map_bloc.dart';

sealed class MapEvent {}

class GetMonumentsEvent extends MapEvent {
  GetMonumentsEvent({
    required this.isRefresh,
    required this.lat,
    required this.lng,
  });

  final bool isRefresh;
  final double lat;
  final double lng;
}
