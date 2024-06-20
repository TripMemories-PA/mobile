import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../component/map_custom.dart';
import '../object/position.dart';
import '../repository/monument/monument_repository.dart';
import '../service/monument/monument_remote_data_source.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                position: Position(
                  swLat: 1,
                  swLng: 1,
                  neLat: 1,
                  neLng: 1,
                ),
              ),
            ),
          child: BlocBuilder<MonumentBloc, MonumentState>(
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
      ),
    );
  }
}
