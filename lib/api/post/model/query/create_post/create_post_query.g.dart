// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'create_post_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePostQueryImpl _$$CreatePostQueryImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePostQueryImpl(
      title: json['title'] as String,
      content: json['content'] as String,
      imageId: (json['imageId'] as num?)?.toInt(),
      poiId: (json['poiId'] as num).toInt(),
      note: (json['note'] as num).toDouble(),
    );

Map<String, dynamic> _$$CreatePostQueryImplToJson(
        _$CreatePostQueryImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'imageId': instance.imageId,
      'poiId': instance.poiId,
      'note': instance.note,
    };
