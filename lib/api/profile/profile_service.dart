import '../../app.config.dart';
import '../../object/profile/profile.dart';
import 'i_profile_service.dart';

class ProfileService implements IProfileService {
  static const String apiProfileUrl = '${AppConfig.apiUrl}/profile';

  @override
  Future<Profile> getProfile(String id) {
    // TODO(nono): implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword({required String password}) {
    // TODO(nono): implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({
    String? userName,
    String? lastName,
    String? firstName,
    String? email,
  }) {
    // TODO(nono): implement updateProfile
    throw UnimplementedError();
  }
}
