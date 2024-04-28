import '../object/profile/profile.dart';
import '../service/profile_interface.dart';
import '../service/profile_local_data_source.dart';
import '../service/profile_remote_data_source.dart';

class ProfileRepository extends ProfileDataSourceInterface {
  ProfileRepository({
    required this.profileRemoteDataSource,
    required this.profilelocalDataSource,
  });

  final ProfileRemoteDataSource profileRemoteDataSource;
  final ProfileLocalDataSource profilelocalDataSource;

  @override
  Future<Profile> getProfile(String id) async {}

  @override
  Future<void> updateProfile(Profile profile) async {}

  @override
  Future<void> updatePassword(String password) async {}
}
