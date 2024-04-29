import '../object/profile/profile.dart';
import '../service/profile_remote_data_source.dart';

// TODO(nono): implement the profilelocalDataSource
class ProfileRepository {
  ProfileRepository({
    required this.profileRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final ProfileRemoteDataSource profileRemoteDataSource;
  //final ProfileLocalDataSource profilelocalDataSource;

  Future<Profile> getProfile(String id) async {
    return profileRemoteDataSource.getProfile(id);
  }

  /*Future<Profile> getLocalProfile(String id) async {
    return profilelocalDataSource.getProfile(id);
  }*/

  Future<void> updateProfile(Profile profile) async {}

  Future<void> updatePassword(String password) async {}
}
