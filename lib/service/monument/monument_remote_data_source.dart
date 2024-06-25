import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../api/monument/monument_service.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/poi/poi.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';
import '../../repository/monument/i_monument_repository.dart';

class MonumentRemoteDataSource implements IMonumentRepository {
  final MonumentService _monumentService = MonumentService();

  @override
  Future<Poi> getMonument(int id) async {
    final Poi poi = await _monumentService.getMonument(id);
    return poi;
  }

  @override
  Future<PoisResponse> getMonuments({
    Position? position,
    bool sortByName = true,
    AlphabeticalSortPossibility order = AlphabeticalSortPossibility.ascending,
    required int page,
    required int perPage,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  }) async {
    final PoisResponse poisResponse = await _monumentService.getMonuments(
      position: position,
      sortByName: sortByName,
      order: order,
      page: page,
      perPage: perPage,
      searchingCriteria: searchingCriteria,
      radius: radius,
    );
    return poisResponse;
  }

  @override
  Future<GetAllPostsResponse> getMonumentPosts({
    required int poiId,
    required int page,
    required int perPage,
  }) async {
    final GetAllPostsResponse postsResponse =
        await _monumentService.getMonumentPosts(
      poiId: poiId,
      page: page,
      perPage: perPage,
    );
    return postsResponse;
  }

  @override
  Future<PoisResponse> getCities(
      {Position? position,
      required bool sortByName,
      required AlphabeticalSortPossibility order,
      required int page,
      required int perPage,
      String? searchingCriteria,
      RadiusQueryInfos? radius}) {}
}
