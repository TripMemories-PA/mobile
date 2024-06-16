import '../../object/avatar/uploaded_file.dart';
import '../../object/post/post.dart';
import 'I_post_service.dart';

class PostService implements IPostService {
  @override
  Future<Post> createPost({required String title, required String content}) {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost({required String postId}) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPoiPosts({required String poiId}) {
    // TODO: implement getPoiPosts
    throw UnimplementedError();
  }

  @override
  Future<Post> getPostById({required String postId}) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

  @override
  Future<Post> updatePost(
      {required String postId,
      String? title,
      String? content,
      UploadFile? image}) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}
