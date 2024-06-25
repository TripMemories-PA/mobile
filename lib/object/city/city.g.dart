// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CityImpl _$$CityImplFromJson(Map<String, dynamic> json) => _$CityImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      zipCode: json['zipCode'] as String,
      coverId: (json['coverId'] as num).toInt(),
      cover: json['cover'] == null
          ? null
          : UploadFile.fromJson(json['cover'] as Map<String, dynamic>),
      averageNote: json['averageNote'] as num?,
    );

Map<String, dynamic> _$$CityImplToJson(_$CityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'zipCode': instance.zipCode,
      'coverId': instance.coverId,
      'cover': instance.cover?.toJson(),
      'averageNote': instance.averageNote,
    };
