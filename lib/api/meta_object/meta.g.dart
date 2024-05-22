// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetaImpl _$$MetaImplFromJson(Map<String, dynamic> json) => _$MetaImpl(
      total: (json['total'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      lastPage: (json['lastPage'] as num).toInt(),
      firstPage: (json['firstPage'] as num).toInt(),
      firstPageUrl: json['firstPageUrl'] as String,
      lastPageUrl: json['lastPageUrl'] as String,
      nextPageUrl: json['nextPageUrl'] as String?,
      previousPageUrl: json['previousPageUrl'] as String?,
    );

Map<String, dynamic> _$$MetaImplToJson(_$MetaImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'perPage': instance.perPage,
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'firstPage': instance.firstPage,
      'firstPageUrl': instance.firstPageUrl,
      'lastPageUrl': instance.lastPageUrl,
      'nextPageUrl': instance.nextPageUrl,
      'previousPageUrl': instance.previousPageUrl,
    };
