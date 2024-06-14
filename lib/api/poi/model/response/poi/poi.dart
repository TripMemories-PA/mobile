import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../object/avatar/uploaded_file.dart';

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
    required double latitude,
    required double longitude,
    required String? city,
    required String? zipCode,
    required String? address,
    required DateTime createdAt,
    required DateTime updatedAt,
    required UploadFile cover,
    required Type type,
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
