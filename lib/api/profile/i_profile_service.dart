import 'package:image_picker/image_picker.dart';

import '../../object/avatar/avatar.dart';
import '../../object/profile/profile.dart';
import 'response/friends/get_friends_pagination_response.dart';

abstract class IProfileService {
  Future<Profile> getProfile({required String id});

  Future<void> updateProfile({
    String? username,
    String? email,
    String? firstName,
    String? lastName,
  });

  Future<void> updatePassword({
    required String password,
  });

  Future<GetFriendsPaginationResponse> getFriends({required String id, required int page, required int perPage});

  Future<UploadFile> updateProfilePicture({
    required XFile image,
  });

  Future<UploadFile> updateProfileBanner({
    required XFile image,
  });
}
