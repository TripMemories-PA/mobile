part of 'map_bloc.dart';


class MapState {
  const MapState({
    this.monuments,
  });

  MapState copyWith({
    List<Poi>? monuments,
  }) {
    return MapState(
      monuments: monuments ?? this.monuments,
    );
  }

  final List<Poi>? monuments;
}
