// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoiImpl _$$PoiImplFromJson(Map<String, dynamic> json) => _$PoiImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      coverId: (json['coverId'] as num?)?.toInt(),
      typeId: (json['typeId'] as num?)?.toInt(),
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cover: UploadFile.fromJson(json['cover'] as Map<String, dynamic>),
      type: Type.fromJson(json['type'] as Map<String, dynamic>),
      postsCount: (json['postsCount'] as num?)?.toInt(),
      averageNote: json['averageNote'] as num?,
    );

Map<String, dynamic> _$$PoiImplToJson(_$PoiImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'coverId': instance.coverId,
      'typeId': instance.typeId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'address': instance.address,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'cover': instance.cover,
      'type': instance.type,
      'postsCount': instance.postsCount,
      'averageNote': instance.averageNote,
    };

_$TypeImpl _$$TypeImplFromJson(Map<String, dynamic> json) => _$TypeImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TypeImplToJson(_$TypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
