import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../component/map_custom.dart';
import '../object/radius.dart';
import '../repository/monument/monument_repository.dart';
import '../service/monument/monument_remote_data_source.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    const LatLng center = LatLng(48.84922330209508, 2.389781701197292);
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => MonumentRepository(
          monumentRemoteDataSource: MonumentRemoteDataSource(),
        ),
        child: BlocProvider(
          create: (context) => MonumentBloc(
            monumentRepository:
                RepositoryProvider.of<MonumentRepository>(context),
          )..add(
              // TODO(nono): donner les coordonnées de la carte
              GetMonumentsOnMapEvent(
                isRefresh: true,
                radius: RadiusQueryInfos(
                  km: 10,
                  lat: center.latitude,
                  lng: center.longitude,
                ),
              ),
            ),
          child: BlocBuilder<MonumentBloc, MonumentState>(
            builder: (context, state) {
              final List<Poi> monuments = state.monuments;
              if (monuments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return MapCustom(
                pois: monuments,
                monumentBloc: BlocProvider.of<MonumentBloc>(context),
              );
            },
          ),
        ),
      ),
    );
  }
}
