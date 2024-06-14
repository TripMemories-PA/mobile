import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/poi/model/response/poi/poi.dart';
import '../api/poi/poi_service.dart';
import '../bloc/map_bloc/map_bloc.dart';
import '../component/map_custom.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MapBloc(poiService: PoiService())
          ..add(
            GetMonumentsEvent(
              isRefresh: true,
              lat: 48.84922330209508,
              lng: 2.389781701197292,
            ),
          ),
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            final List<Poi> monuments = state.monuments ?? [];
            if (monuments.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return MapCustom(
              pois: monuments,
            );
          },
        ),
      ),
    );
  }
}
