// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'get_friends_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetFriendsPaginationResponseImpl _$$GetFriendsPaginationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetFriendsPaginationResponseImpl(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetFriendsPaginationResponseImplToJson(
        _$GetFriendsPaginationResponseImpl instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };
