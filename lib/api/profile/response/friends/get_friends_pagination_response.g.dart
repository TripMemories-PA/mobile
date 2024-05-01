// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_friends_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetFriendsPaginationResponseImpl _$$GetFriendsPaginationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetFriendsPaginationResponseImpl(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetFriendsPaginationResponseImplToJson(
        _$GetFriendsPaginationResponseImpl instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };

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

_$DataImpl _$$DataImplFromJson(Map<String, dynamic> json) => _$DataImpl();

Map<String, dynamic> _$$DataImplToJson(_$DataImpl instance) =>
    <String, dynamic>{};
