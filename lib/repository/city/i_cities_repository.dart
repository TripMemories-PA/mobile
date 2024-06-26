import '../../api/city/model/response/cities_response/cities_response.dart';
import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
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

  Future<PoisResponse> getCityMonuments({
    required int cityId,
    required int page,
    required int perPage,
  });

  Future<GetAllPostsResponse> getCityPosts({
    required int cityId,
    required int page,
    required int perPage,
  });
}
