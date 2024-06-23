import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../object/avatar/uploaded_file.dart';
import '../city/city.dart';

part 'poi.freezed.dart';
part 'poi.g.dart';

@freezed
class Poi with _$Poi {
  const factory Poi({
    required int id,
    required String name,
    required String? description,
    required int? coverId,
    required int? typeId,
    required String latitude,
    required String longitude,
    required City? city,
    required String? address,
    required DateTime createdAt,
    required DateTime updatedAt,
    required UploadFile cover,
    required Type type,
    required int? postsCount,
    required num? averageNote,
  }) = _Poi;

  factory Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);
}

@freezed
class Type with _$Type {
  const factory Type({
    required int id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Type;

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);
}
