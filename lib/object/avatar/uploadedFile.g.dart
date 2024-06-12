// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadFileImpl _$$UploadFileImplFromJson(Map<String, dynamic> json) =>
    _$UploadFileImpl(
      id: (json['id'] as num).toInt(),
      filename: json['filename'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UploadFileImplToJson(_$UploadFileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mimeType': instance.mimeType,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
