import '../api/profile/profile_service.dart';
import '../object/profile/profile.dart';
import 'profile_interface.dart';

class ProfileRemoteDataSource extends ProfileDataSourceInterface {
  final ProfileService _profileService = ProfileService();

  @override
  Future<Profile> getProfile(String id) async {
    final Profile profile = await _profileService.getProfile(id: id);
    return profile;
  }
}
