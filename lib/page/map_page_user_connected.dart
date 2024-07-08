import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../component/map_custom.dart';
import '../object/radius.dart';
import '../repository/monument/monument_repository.dart';
import '../repository/profile/profile_repository.dart';

class MapPageUserConnected extends StatelessWidget {
  const MapPageUserConnected({super.key});

  @override
  Widget build(BuildContext context) {
    const LatLng center = LatLng(48.84922330209508, 2.389781701197292);
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MonumentBloc(
                monumentRepository:
                    RepositoryProvider.of<MonumentRepository>(context),
              )..add(
                  GetMonumentsOnMapEvent(
                    isRefresh: true,
                    radius: RadiusQueryInfos(
                      km: 10,
                      lat: center.latitude,
                      lng: center.longitude,
                    ),
                  ),
                ),
            ),
            if (context.read<AuthBloc>().state.status ==
                    AuthStatus.authenticated &&
                context.read<AuthBloc>().state.user?.userTypeId == 2)
              BlocProvider(
                create: (context) => ProfileBloc(
                  profileRepository:
                      RepositoryProvider.of<ProfileRepository>(context),
                  profileService: ProfileService(),
                )..add(
                    GetFriendsEvent(
                      isRefresh: true,
                      radius: RadiusQueryInfos(
                        km: 10,
                        lat: center.latitude,
                        lng: center.longitude,
                      ),
                      isOnMap: true,
                    ),
                  ),
              ),
          ],
          child: BlocBuilder<MonumentBloc, MonumentState>(
            builder: (context, state) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return MapCustom(
                    monumentBloc: BlocProvider.of<MonumentBloc>(context),
                    profileBloc: BlocProvider.of<ProfileBloc>(context),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
