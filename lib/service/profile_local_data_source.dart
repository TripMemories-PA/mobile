import '../object/profile/profile.dart';
import 'profile_interface.dart';

class ProfileLocalDataSource extends ProfileDataSourceInterface {
  ProfileLocalDataSource();

  @override
  Future<Profile> getProfile(String id) async {}

  @override
  Future<void> updateProfile(Profile profile) async {}

  @override
  Future<void> updatePassword(String password) async {}
}
