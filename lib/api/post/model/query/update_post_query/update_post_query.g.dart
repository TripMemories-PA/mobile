// ignore_for_file: type=lint
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_post_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdatePostQueryImpl _$$UpdatePostQueryImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdatePostQueryImpl(
      postId: (json['postId'] as num).toInt(),
      content: json['content'] as String?,
      imageId: (json['imageId'] as num?)?.toInt(),
      poiId: (json['poiId'] as num?)?.toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$UpdatePostQueryImplToJson(
        _$UpdatePostQueryImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'content': instance.content,
      'imageId': instance.imageId,
      'poiId': instance.poiId,
      'note': instance.note,
    };
