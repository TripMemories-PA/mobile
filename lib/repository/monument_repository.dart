import '../api/monument/model/response/poi/poi.dart';
import '../api/monument/model/response/pois_response/pois_response.dart';
import '../object/position.dart';
import '../object/sort_possibility.dart';
import '../service/monument/monument_remote_data_source.dart';

// TODO(nono): implement the monumentlocalDataSource
class MonumentRepository {
  MonumentRepository({
    required this.monumentRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final MonumentRemoteDataSource monumentRemoteDataSource;

  //final ProfileLocalDataSource profilelocalDataSource;

  Future<Poi> getMonument(int id) async {
    return monumentRemoteDataSource.getMonument(id);
  }

  Future<PoisResponse> getMonuments({
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
  }) async {
    return monumentRemoteDataSource.getMonuments(
      position: position,
      sortByName: sortByName,
      order: order,
      page: page,
      perPage: perPage,
      searchingCriteria: searchingCriteria,
    );
  }
}
