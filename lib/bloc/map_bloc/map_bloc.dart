import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/poi/i_poi_service.dart';
import '../../api/poi/model/response/poi/poi.dart';
import '../../api/poi/model/response/pois_response/pois_response.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required this.poiService}) : super(const MapState()) {
    on<GetMonumentsEvent>((event, emit) async {
      final PoisResponse monuments = await poiService.getPois(
        page: 1,
        perPage: 50,
        xx: 1,
        xy: 1,
        yx: 1,
        yy: 1,
      );
      emit(
        state.copyWith(
          monuments: monuments.data,
        ),
      );
    });
  }

  IPoiService poiService;
}
