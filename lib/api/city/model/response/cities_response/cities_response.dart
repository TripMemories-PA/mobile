import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../object/city/city.dart';
import '../../../../meta_object/meta.dart';

part 'cities_response.freezed.dart';
part 'cities_response.g.dart';

@freezed
class CitiesResponse with _$CitiesResponse {
  const factory CitiesResponse({
    required Meta meta,
    required List<City> data,
  }) = _CitiesResponse;

  factory CitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$CitiesResponseFromJson(json);
}
