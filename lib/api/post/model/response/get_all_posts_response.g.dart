// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'get_all_posts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetAllPostsResponseImpl _$$GetAllPostsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetAllPostsResponseImpl(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetAllPostsResponseImplToJson(
        _$GetAllPostsResponseImpl instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };
