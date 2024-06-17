import '../post/model/response/get_all_posts_response.dart';
import 'model/response/pois_response/pois_response.dart';

abstract class IPoiService {
  Future<PoisResponse> getPois({
    required int page,
    required int perPage,
    required double xx,
    required double xy,
    required double yx,
    required double yy,
  });

  Future<GetAllPostsResponse> getPoisPosts({
    required int poiId,
    required int page,
    required int perPage,
  });
}
