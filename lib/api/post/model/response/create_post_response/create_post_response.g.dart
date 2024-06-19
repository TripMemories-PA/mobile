// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePostResponseImpl _$$CreatePostResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePostResponseImpl(
      createdById: (json['createdById'] as num).toInt(),
      poiId: (json['poiId'] as num).toInt(),
      content: json['content'] as String,
      imageId: (json['imageId'] as num).toInt(),
      note: (json['note'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$$CreatePostResponseImplToJson(
        _$CreatePostResponseImpl instance) =>
    <String, dynamic>{
      'createdById': instance.createdById,
      'poiId': instance.poiId,
      'content': instance.content,
      'imageId': instance.imageId,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
    };
