// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CitiesResponseImpl _$$CitiesResponseImplFromJson(Map<String, dynamic> json) =>
    _$CitiesResponseImpl(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CitiesResponseImplToJson(
  _$CitiesResponseImpl instance,
) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };
