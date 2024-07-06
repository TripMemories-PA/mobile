import '../../../../object/city.dart';
import '../../../../object/meta_object.dart';

class CitiesResponse {
  CitiesResponse({
    required this.meta,
    required this.data,
  });

  factory CitiesResponse.fromJson(Map<String, dynamic> json) {
    return CitiesResponse(
      meta: MetaObject.fromJson(json['meta']),
      data: List<City>.from(json['data'].map((x) => City.fromJson(x))),
    );
  }

  MetaObject meta;
  List<City> data;
}
