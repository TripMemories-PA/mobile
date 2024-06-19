import '../../object/position.dart';
import '../../object/sort_possibility.dart';
import '../post/model/response/get_all_posts_response.dart';
import 'model/response/poi/poi.dart';
import 'model/response/pois_response/pois_response.dart';

abstract class IMonumentService {
  Future<Poi> getMonument(int id);

  Future<PoisResponse> getMonuments({
    required int page,
    required int perPage,
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
  });

  Future<GetAllPostsResponse> getMonumentPosts({
    required int poiId,
    required int page,
    required int perPage,
  });
}
