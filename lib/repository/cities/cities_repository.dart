import '../../api/city/model/response/cities_response/cities_response.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';
import '../../service/cities/cities_remote_data_source.dart';
import 'i_cities_repository.dart';

// TODO(nono): implement the monumentlocalDataSource
class CityRepository implements ICityRepository {
  CityRepository({
    required this.citiesRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final CityRemoteDataSource citiesRemoteDataSource;

  //final ProfileLocalDataSource profilelocalDataSource;

  @override
  Future<CitiesResponse> getCities({
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  }) {
    return citiesRemoteDataSource.getCities(
      position: position,
      sortByName: sortByName,
      order: order,
      page: page,
      perPage: perPage,
      searchingCriteria: searchingCriteria,
      radius: radius,
    );
  }
}
