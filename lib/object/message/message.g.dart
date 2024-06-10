// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: (json['id'] as num).toInt(),
      sender: Profile.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: Profile.fromJson(json['receiver'] as Map<String, dynamic>),
      message: json['message'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      avatar: json['avatar'] == null
          ? null
          : UploadFile.fromJson(json['avatar'] as Map<String, dynamic>),
      banner: json['banner'] == null
          ? null
          : UploadFile.fromJson(json['banner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender.toJson(),
      'receiver': instance.receiver.toJson(),
      'message': instance.message,
      'sentAt': instance.sentAt.toIso8601String(),
      'avatar': instance.avatar?.toJson(),
      'banner': instance.banner?.toJson(),
    };
