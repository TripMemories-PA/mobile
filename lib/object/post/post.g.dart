// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: (json['id'] as num).toInt(),
      poiId: (json['poiId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      note: json['note'] as String,
      image: json['image'] == null
          ? null
          : UploadFile.fromJson(json['image'] as Map<String, dynamic>),
      imageId: (json['imageId'] as num?)?.toInt(),
      createdBy: Profile.fromJson(json['createdBy'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      likesCount: (json['likesCount'] as num).toInt(),
      commentsCount: (json['commentsCount'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      poi: Poi.fromJson(json['poi'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poiId': instance.poiId,
      'title': instance.title,
      'content': instance.content,
      'note': instance.note,
      'image': instance.image,
      'imageId': instance.imageId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'isLiked': instance.isLiked,
      'poi': instance.poi,
    };
