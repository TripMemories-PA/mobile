// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      isFriend: json['isFriend'] as bool?,
      hasSentFriendRequest: json['hasSentFriendRequest'] as bool?,
      hasReceivedFriendRequest: json['hasReceivedFriendRequest'] as bool?,
      avatar: json['avatar'] == null
          ? null
          : UploadFile.fromJson(json['avatar'] as Map<String, dynamic>),
      banner: json['banner'] == null
          ? null
          : UploadFile.fromJson(json['banner'] as Map<String, dynamic>),
      poisCount: (json['poisCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'isFriend': instance.isFriend,
      'hasSentFriendRequest': instance.hasSentFriendRequest,
      'hasReceivedFriendRequest': instance.hasReceivedFriendRequest,
      'avatar': instance.avatar?.toJson(),
      'banner': instance.banner?.toJson(),
      'poisCount': instance.poisCount,
    };
