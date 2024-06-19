import '../../api/monument/model/response/poi/poi.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../object/position.dart';
import '../../object/sort_possibility.dart';

abstract class MonumentDataSourceInterface {
  Future<Poi> getMonument(int id);

  Future<PoisResponse> getMonuments({
    Position? position,
    bool sortByName = true,
    AlphabeticalSortPossibility order = AlphabeticalSortPossibility.ascending,
    required int page,
    required int perPage,
  });
}
