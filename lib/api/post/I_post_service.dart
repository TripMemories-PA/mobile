import '../../object/avatar/uploaded_file.dart';
import '../../object/post/post.dart';

abstract class IPostService {
  Future<Post> createPost({
    required String title,
    required String content,
  });

  Future<Post> getPostById({
    required String postId,
  });

  Future<List<Post>> getPoiPosts({
    required String poiId,
  });

  Future<List<Post>> getPosts();

  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    UploadFile? image,
  });

  Future<void> deletePost({
    required String postId,
  });
}
