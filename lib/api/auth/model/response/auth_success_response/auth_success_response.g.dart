// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSuccessResponseImpl _$$AuthSuccessResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthSuccessResponseImpl(
      type: json['type'] as String,
      token: json['token'] as String,
      expiresAt: json['expires_at'] as String,
    );

Map<String, dynamic> _$$AuthSuccessResponseImplToJson(
        _$AuthSuccessResponseImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'token': instance.token,
      'expires_at': instance.expiresAt,
    };
