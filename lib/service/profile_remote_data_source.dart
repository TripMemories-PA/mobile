import '../object/profile/profile.dart';
import 'profile_interface.dart';

class ProfileRemoteDataSource extends ProfileDataSourceInterface {
  ProfileRemoteDataSource();

  @override
  Future<Profile> getProfile(String id) async {}

  @override
  Future<void> updateProfile(Profile profile) async {}

  @override
  Future<void> updatePassword(String password) async {}
}
