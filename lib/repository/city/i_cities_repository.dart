import '../../api/city/model/response/cities_response.dart';
import '../../api/monument/model/response/pois_response.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';

abstract class ICityRepository {
  Future<CitiesResponse> getCities({
    PositionDataCustom? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  });

  Future<PoisResponse> getCityMonuments({
    required int cityId,
    required int page,
    required int perPage,
  });
}
