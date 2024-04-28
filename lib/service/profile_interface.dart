import '../object/profile/profile.dart';

abstract class ProfileDataSourceInterface {
  Future<Profile> getProfile(String id);
  Future<void> updateProfile(Profile profile);
  Future<void> updatePassword(String password);
}
