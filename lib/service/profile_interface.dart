import '../object/profile/profile.dart';

abstract class ProfileDataSourceInterface {
  Future<Profile> getProfile(String id);
}
