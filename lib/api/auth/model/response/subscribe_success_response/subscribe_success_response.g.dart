// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscribeSuccessResponseImpl _$$SubscribeSuccessResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscribeSuccessResponseImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$$SubscribeSuccessResponseImplToJson(
        _$SubscribeSuccessResponseImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'id': instance.id,
    };
