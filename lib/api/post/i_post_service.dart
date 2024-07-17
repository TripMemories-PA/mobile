import 'package:image_picker/image_picker.dart';

import 'model/query/create_post_query.dart';
import 'model/response/create_post_response.dart';

abstract class IPostService {
  Future<CreatePostResponse> createPost({
    required CreatePostQuery query,
  });

  Future<void> deletePost({
    required int postId,
  });

  Future<int> publishImage({
    required XFile image,
  });

  Future<void> likePost({
    required int postId,
  });

  Future<void> dislikePost({
    required int postId,
  });

  Future<void> reportPost({
    required int postId,
  });
}
