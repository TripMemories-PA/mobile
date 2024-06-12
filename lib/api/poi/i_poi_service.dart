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
}
