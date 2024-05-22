// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'auth_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSuccessResponseImpl _$$AuthSuccessResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthSuccessResponseImpl(
      type: json['type'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$$AuthSuccessResponseImplToJson(
        _$AuthSuccessResponseImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'token': instance.token,
    };
