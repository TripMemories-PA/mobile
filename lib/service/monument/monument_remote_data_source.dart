import '../../api/monument/model/response/poi/poi.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../api/monument/monument_service.dart';
import '../../object/position.dart';
import '../../object/sort_possibility.dart';
import 'monument_interface.dart';

class MonumentRemoteDataSource extends MonumentDataSourceInterface {
  final MonumentService _monumentService = MonumentService();

  @override
  Future<Poi> getMonument(int id) async {
    final Poi poi = await _monumentService.getMonument(id);
    return poi;
  }

  @override
  Future<PoisResponse> getMonuments({
    Position? position,
    bool sortByName = true,
    AlphabeticalSortPossibility order = AlphabeticalSortPossibility.ascending,
    required int page,
    required int perPage,
    String? searchingCriteria,
  }) async {
    final PoisResponse poisResponse = await _monumentService.getMonuments(
      position: position,
      sortByName: sortByName,
      order: order,
      page: page,
      perPage: perPage,
      searchingCriteria: searchingCriteria,
    );
    return poisResponse;
  }
}
