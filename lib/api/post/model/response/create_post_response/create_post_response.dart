import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_response.freezed.dart';
part 'create_post_response.g.dart';

@Freezed()
class CreatePostResponse with _$CreatePostResponse {
  const factory CreatePostResponse({
    required int createdById,
    required int poiId,
    required String content,
    required int imageId,
    required double note,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int id,
  }) = _CreatePostResponse;

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePostResponseFromJson(json);
}
