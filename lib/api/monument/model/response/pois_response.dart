import '../../../../object/meta_object.dart';
import '../../../../object/poi/poi.dart';

class PoisResponse {
  PoisResponse({
    required this.meta,
    required this.data,
  });

  factory PoisResponse.fromJson(Map<String, dynamic> json) {
    return PoisResponse(
      meta: MetaObject.fromJson(json['meta']),
      data: List<Poi>.from(
        json['data'].map((x) => Poi.fromJson(x)),
      ),
    );
  }

  MetaObject meta;
  List<Poi> data;
}
