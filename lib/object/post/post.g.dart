// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: (json['id'] as num).toInt(),
      poiId: (json['poiId'] as num).toInt(),
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
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poiId': instance.poiId,
      'content': instance.content,
      'note': instance.note,
      'image': instance.image,
      'imageId': instance.imageId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
