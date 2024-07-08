import '../../api/monument/model/response/pois_response.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/poi/poi.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';
import '../../service/monument/monument_remote_data_source.dart';
import 'i_monument_repository.dart';

// TODO(nono): implement the monumentlocalDataSource
class MonumentRepository implements IMonumentRepository {
  MonumentRepository({
    required this.monumentRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final MonumentRemoteDataSource monumentRemoteDataSource;

  //final ProfileLocalDataSource profilelocalDataSource;

  @override
  Future<Poi> getMonument(int id) async {
    return monumentRemoteDataSource.getMonument(id);
  }

  @override
  Future<PoisResponse> getMonuments({
    PositionDataCustom? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  }) async {
    return monumentRemoteDataSource.getMonuments(
      position: position,
      sortByName: sortByName,
      order: order,
      page: page,
      perPage: perPage,
      searchingCriteria: searchingCriteria,
      radius: radius,
    );
  }

  @override
  Future<GetAllPostsResponse> getMonumentPosts({
    required int poiId,
    required int page,
    required int perPage,
  }) {
    return monumentRemoteDataSource.getMonumentPosts(
      poiId: poiId,
      page: page,
      perPage: perPage,
    );
  }
}
