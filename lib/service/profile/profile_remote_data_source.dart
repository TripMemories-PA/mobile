import '../../api/profile/profile_service.dart';
import '../../api/profile/response/friend_request_response.dart';
import '../../api/profile/response/get_friends_pagination_response.dart';
import '../../object/position.dart';
import '../../object/profile.dart';
import '../../object/radius.dart';
import 'profile_interface.dart';

class ProfileRemoteDataSource extends ProfileDataSourceInterface {
  final ProfileService _profileService = ProfileService();

  @override
  Future<Profile> whoAmI() async {
    final Profile profile = await _profileService.whoAmI();
    return profile;
  }

  @override
  Future<Profile> getProfile(int id) async {
    final Profile profile = await _profileService.getProfile(id);
    return profile;
  }

  @override
  Future<GetFriendsPaginationResponse> getMyFriends({
    required int page,
    required int perPage,
    PositionDataCustom? position,
    RadiusQueryInfos? radius,
  }) async {
    final GetFriendsPaginationResponse friends =
        await _profileService.getMyFriends(
      page: page,
      perPage: perPage,
      position: position,
      radius: radius,
    );
    return friends;
  }

  @override
  Future<GetFriendRequestResponse> getMyFriendRequests({
    required int page,
    required int perPage,
  }) async {
    final GetFriendRequestResponse friendRequests =
        await _profileService.getMyFriendRequests(page: page, perPage: perPage);
    return friendRequests;
  }

  @override
  Future<GetFriendsPaginationResponse> getUsers({
    required int page,
    required int perPage,
    String? searchName,
    bool? sortByScore,
  }) async {
    final GetFriendsPaginationResponse friendRequests =
        await _profileService.getUsers(
      page: page,
      perPage: perPage,
      searchName: searchName,
      sortByScore: sortByScore,
    );
    return friendRequests;
  }
}
