import '../../api/city/model/response/cities_response/cities_response.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';

abstract class ICityRepository {
  Future<CitiesResponse> getCities({
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  });
}
