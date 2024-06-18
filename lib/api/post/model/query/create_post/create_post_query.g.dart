// ignore_for_file: type=lint
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePostQueryImpl _$$CreatePostQueryImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePostQueryImpl(
      content: json['content'] as String,
      imageId: (json['imageId'] as num).toInt(),
      poiId: (json['poiId'] as num).toInt(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$$CreatePostQueryImplToJson(
        _$CreatePostQueryImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'imageId': instance.imageId,
      'poiId': instance.poiId,
      'note': instance.note,
    };
