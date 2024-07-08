import '../../api/profile/response/friend_request_response.dart';
import '../../api/profile/response/get_friends_pagination_response.dart';
import '../../object/position.dart';
import '../../object/profile.dart';
import '../../object/radius.dart';
import '../../service/profile/profile_remote_data_source.dart';
import 'i_profile_repository.dart';

// TODO(nono): implement the profilelocalDataSource
class ProfileRepository implements IProfileRepository {
  ProfileRepository({
    required this.profileRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final ProfileRemoteDataSource profileRemoteDataSource;

  //final ProfileLocalDataSource profilelocalDataSource;

  @override
  Future<Profile> getProfile(int id) async {
    return profileRemoteDataSource.getProfile(id);
  }

  @override
  Future<Profile> whoAmI() async {
    return profileRemoteDataSource.whoAmI();
  }

  @override
  Future<GetFriendsPaginationResponse> getMyFriends({
    required int page,
    required int perPage,
    PositionDataCustom? position,
    RadiusQueryInfos? radius,
  }) async {
    return profileRemoteDataSource.getMyFriends(
      page: page,
      perPage: perPage,
      position: position,
      radius: radius,
    );
  }

  @override
  Future<GetFriendRequestResponse> getMyFriendRequests({
    required int page,
    required int perPage,
  }) async {
    return profileRemoteDataSource.getMyFriendRequests(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<GetFriendsPaginationResponse> getUsers({
    required int page,
    required int perPage,
    String? searchName,
  }) async {
    return profileRemoteDataSource.getUsers(
      page: page,
      perPage: perPage,
      searchName: searchName,
    );
  }
}
