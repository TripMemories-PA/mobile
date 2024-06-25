import '../../api/city/city_service.dart';
import '../../api/city/model/response/cities_response/cities_response.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';
import '../../repository/cities/i_cities_repository.dart';

class CityRemoteDataSource implements ICityRepository {
  final CityServiceService _cityService = CityServiceService();

  @override
  Future<CitiesResponse> getCities({
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  }) async {
    final CitiesResponse citiesResponse = await _cityService.getCities(
      position: position,
      sortByName: sortByName,
      order: order,
      page: page,
      perPage: perPage,
      searchingCriteria: searchingCriteria,
      radius: radius,
    );
    return citiesResponse;
  }
}
