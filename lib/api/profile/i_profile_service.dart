import '../../object/profile/profile.dart';

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
}
