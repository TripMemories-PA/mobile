import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.config.dart';
import '../../object/position.dart';
import '../../object/profile.dart';
import '../../object/radius.dart';
import '../../object/uploaded_file.dart';
import '../../repository/profile/i_profile_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_profile_service.dart';
import 'response/friend_request_response.dart';
import 'response/get_friends_pagination_response.dart';

// TODO(nono): gestion des erreurs notamment pour le username qui a des restrictions de nommage
class ProfileService implements IProfileService, IProfileRepository {
  static const String apiMeUrl = '${AppConfig.apiUrl}/me';
  static const String apiMyAvatarUrl = '$apiMeUrl/avatar';
  static const String apiMyBannerUrl = '$apiMeUrl/banner';
  static const String apiMyFriendsUrl =
      '$apiMeUrl/friends/?page=[nb_page]&perPage=[per_page]';
  static const String apiMyFriendRequestsBaseUrl = '$apiMeUrl/friend-requests';
  static const String apiMyFriendRequestsUrl =
      '$apiMyFriendRequestsBaseUrl/?page=[nb_page]&perPage=[per_page]';
  static const String apiUserUrl = '${AppConfig.apiUrl}/users';
  static const String apiAcceptFriendRequestUrl =
      '$apiMyFriendRequestsBaseUrl/[friend_request_id]/accept';
  static const String apiUsersUrl =
      '${AppConfig.apiUrl}/users?page=[nb_page]&perPage=[per_page]';
  static const String apiFriendRequestsUrl = '$apiMeUrl/friend-requests';
  static const String apiMyPostsUrl =
      '$apiMeUrl/posts?page=[nb_page]&perPage=[per_page]';
  static const String apiPostUrl = '${AppConfig.apiUrl}/posts';

  @override
  Future<Profile> getProfile(id) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '$apiUserUrl/$id',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Profile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<Profile> whoAmI() async {
    Response response;
    try {
      response = await DioClient.instance.get(
        apiMeUrl,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Profile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    try {
      await DioClient.instance.put(
        '$apiMeUrl/password',
        data: {
          'password': password,
        },
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> updateProfile({
    String? username,
    String? lastName,
    String? firstName,
    String? email,
  }) async {
    await DioClient.instance.put(
      apiMeUrl,
      data: {
        'username': username,
        'lastname': lastName,
        'firstname': firstName,
        'email': email,
      },
    );
  }

  @override
  Future<GetFriendsPaginationResponse> getMyFriends({
    required int page,
    required int perPage,
    PositionDataCustom? position,
    RadiusQueryInfos? radius,
  }) async {
    Response response;
    String url = apiMyFriendsUrl
        .replaceAll('[nb_page]', page.toString())
        .replaceAll('[per_page]', perPage.toString());
    if (position != null) {
      url +=
          '&swLng=${position.swLng}&swLat=${position.swLat}&neLng=${position.neLng}&neLat=${position.neLat}';
    } else if (radius != null) {
      url += '&radius=${radius.km}&lng=${radius.lng}&lat=${radius.lat}';
    }
    try {
      response = await DioClient.instance.get(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return GetFriendsPaginationResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<GetFriendRequestResponse> getMyFriendRequests({
    required int page,
    required int perPage,
  }) async {
    Response response;
    final String url = apiMyFriendRequestsUrl
        .replaceAll('[nb_page]', page.toString())
        .replaceAll('[per_page]', perPage.toString());
    try {
      response = await DioClient.instance.get(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return GetFriendRequestResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<GetFriendsPaginationResponse> getUsers({
    required int page,
    required int perPage,
    String? searchName,
    bool? sortByScore,
  }) async {
    Response response;
    String url = apiUsersUrl
        .replaceAll('[nb_page]', page.toString())
        .replaceAll('[per_page]', perPage.toString());

    if (searchName != null) {
      url = '$url&search=$searchName';
    }
    if (sortByScore != null) {
      url = '$url&sortBy=score&order=desc';
    }
    try {
      response = await DioClient.instance.get(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return GetFriendsPaginationResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<UploadFile> updateProfilePicture({
    required XFile image,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        apiMyAvatarUrl,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return UploadFile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<UploadFile> updateProfileBanner({
    required XFile image,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        apiMyBannerUrl,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return UploadFile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> sendFriendRequest({required String userId}) async {
    try {
      await DioClient.instance.post(
        apiFriendRequestsUrl,
        data: {
          'userId': int.parse(userId),
        },
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> acceptFriendRequest({required String friendRequestId}) async {
    try {
      final String url = apiAcceptFriendRequestUrl.replaceAll(
        '[friend_request_id]',
        friendRequestId,
      );
      await DioClient.instance.put(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> rejectFriendRequest({required String friendRequestId}) async {
    try {
      final String url = '$apiMyFriendRequestsBaseUrl/$friendRequestId';
      await DioClient.instance.delete(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> removeFriend({required int friendId}) async {
    try {
      final String url = '$apiMeUrl/friends/$friendId';
      await DioClient.instance.delete(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }
}
