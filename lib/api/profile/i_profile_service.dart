import 'package:image_picker/image_picker.dart';

import '../../object/avatar/uploaded_file.dart';

abstract class IProfileService {
  Future<void> updateProfile({
    String? username,
    String? email,
    String? firstName,
    String? lastName,
  });

  Future<void> updatePassword({
    required String password,
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

  Future<void> deletePost({required int postId});
}
