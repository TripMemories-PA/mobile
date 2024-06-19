import 'package:image_picker/image_picker.dart';

import '../../object/avatar/uploaded_file.dart';
import '../../object/profile/profile.dart';
import '../post/model/response/get_all_posts_response.dart';
import 'response/friend_request/friend_request_response.dart';
import 'response/friends/get_friends_pagination_response.dart';

abstract class IProfileService {
  Future<Profile> getProfile({required int id});

  Future<Profile> whoAmI();

  Future<void> updateProfile({
    String? username,
    String? email,
    String? firstName,
    String? lastName,
  });

  Future<void> updatePassword({
    required String password,
  });

  Future<GetFriendsPaginationResponse> getMyFriends({
    required int page,
    required int perPage,
  });

  Future<GetFriendRequestResponse> getMyFriendRequests({
    required int page,
    required int perPage,
  });

  Future<GetFriendsPaginationResponse> getUsers({
    required int page,
    required int perPage,
    String? searchName,
  });

  Future<UploadFile> updateProfilePicture({
    required XFile image,
  });

  Future<UploadFile> updateProfileBanner({
    required XFile image,
  });

  Future<void> acceptFriendRequest({required String friendRequestId});

  Future<void> sendFriendRequest({required String userId});

  Future<void> rejectFriendRequest({required String friendRequestId});

  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  });

  Future<void> deletePost({required int postId});
}
