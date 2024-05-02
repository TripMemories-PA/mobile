import '../api/profile/profile_service.dart';
import '../api/profile/response/friends/get_friends_pagination_response.dart';
import '../object/profile/profile.dart';
import 'profile_interface.dart';

class ProfileRemoteDataSource extends ProfileDataSourceInterface {
  final ProfileService _profileService = ProfileService();

  @override
  Future<Profile> getProfile(String id) async {
    final Profile profile = await _profileService.getProfile(id: id);
    return profile;
  }

  @override
  Future<GetFriendsPaginationResponse> getFriends({required String id,  required int page, required int perPage}) async {
    final GetFriendsPaginationResponse friends = await _profileService.getFriends(id: id, page: page, perPage: perPage);
    return friends;
  }
}
