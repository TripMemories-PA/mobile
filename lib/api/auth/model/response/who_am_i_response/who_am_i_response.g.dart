// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'who_am_i_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WhoAmIResponseImpl _$$WhoAmIResponseImplFromJson(Map<String, dynamic> json) =>
    _$WhoAmIResponseImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      avatar: json['avatar'] as String?,
      sentFriendRequests: (json['sentFriendRequests'] as List<dynamic>?)
          ?.map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      receivedFriendRequests: (json['receivedFriendRequests'] as List<dynamic>?)
          ?.map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      friends: json['friends'] as List<dynamic>?,
    );

Map<String, dynamic> _$$WhoAmIResponseImplToJson(
        _$WhoAmIResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'avatar': instance.avatar,
      'sentFriendRequests': instance.sentFriendRequests,
      'receivedFriendRequests': instance.receivedFriendRequests,
      'friends': instance.friends,
    };
