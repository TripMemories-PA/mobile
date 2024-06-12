// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pois_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoisResponseImpl _$$PoisResponseImplFromJson(Map<String, dynamic> json) =>
    _$PoisResponseImpl(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => Poi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PoisResponseImplToJson(_$PoisResponseImpl instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };
