import '../../object/profile/profile.dart';

abstract class IProfileService {
  Future<Profile> getProfile(String id);

  Future<void> updateProfile({
    String? userName,
    String? lastName,
    String? firstName,
    String? email,
  });

  Future<void> updatePassword({
    required String password,
  });
}
