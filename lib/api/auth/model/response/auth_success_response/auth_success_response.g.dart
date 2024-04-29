// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'auth_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSuccessResponseImpl _$$AuthSuccessResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthSuccessResponseImpl(
      authToken: json['authToken'] as String,
      user: UserElementLogInResponse.fromJson(
          json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthSuccessResponseImplToJson(
        _$AuthSuccessResponseImpl instance) =>
    <String, dynamic>{
      'authToken': instance.authToken,
      'user': instance.user.toJson(),
    };
