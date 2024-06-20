import '../../api/monument/model/response/poi/poi.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/position.dart';
import '../../object/sort_possibility.dart';

// TODO(nono): implement the monumentlocalDataSource
abstract class IMonumentRepository {
  Future<Poi> getMonument(int id);

  Future<PoisResponse> getMonuments({
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
  });

  Future<GetAllPostsResponse> getMonumentPosts({
    required int poiId,
    required int page,
    required int perPage,
  });
}
