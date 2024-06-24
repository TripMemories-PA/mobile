// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: (json['id'] as num).toInt(),
      postId: (json['postId'] as num).toInt(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: Profile.fromJson(json['createdBy'] as Map<String, dynamic>),
      likesCount: (json['likesCount'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'likesCount': instance.likesCount,
      'isLiked': instance.isLiked,
    };
