import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/monument/model/response/poi/poi.dart';
import '../avatar/uploaded_file.dart';
import '../profile/profile.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@Freezed()
class Post with _$Post {
  const factory Post({
    required int id,
    required int poiId,
    required String title,
    required String content,
    required String note,
    required UploadFile? image,
    required int? imageId,
    required Profile createdBy,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required int likesCount,
    required int commentsCount,
    required bool isLiked,
    required Poi poi,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}