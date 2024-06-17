// ignore_for_file: type=lint
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCommentQueryImpl _$$PostCommentQueryImplFromJson(
        Map<String, dynamic> json) =>
    _$PostCommentQueryImpl(
      content: json['content'] as String,
      postId: (json['postId'] as num).toInt(),
    );

Map<String, dynamic> _$$PostCommentQueryImplToJson(
        _$PostCommentQueryImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'postId': instance.postId,
    };
