import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../meta_object/meta.dart';
import '../poi/poi.dart';

part 'pois_response.freezed.dart';
part 'pois_response.g.dart';

@freezed
class PoisResponse with _$PoisResponse {
  const factory PoisResponse({
    required Meta meta,
    required List<Poi> data,
  }) = _PoisResponse;

  factory PoisResponse.fromJson(Map<String, dynamic> json) =>
      _$PoisResponseFromJson(json);
}
