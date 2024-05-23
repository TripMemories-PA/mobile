// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'subscribe_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscribeSuccessResponseImpl _$$SubscribeSuccessResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscribeSuccessResponseImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$$SubscribeSuccessResponseImplToJson(
        _$SubscribeSuccessResponseImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'id': instance.id,
    };
