import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.config.dart';
import '../../object/avatar/uploaded_file.dart';
import '../../object/profile/profile.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_profile_service.dart';
import 'response/friend_request/friend_request_response.dart';
import 'response/friends/get_friends_pagination_response.dart';

class ProfileService implements IProfileService {
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

  @override
  Future<Profile> getProfile({required String id}) async {
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
  Future<void> updatePassword({required String password}) {
    // TODO(nono): implement updateProfile
    throw UnimplementedError();
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
  }) async {
    Response response;
    final String url = apiMyFriendsUrl
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
  }) async {
    Response response;
    String url = apiUsersUrl
        .replaceAll('[nb_page]', page.toString())
        .replaceAll('[per_page]', perPage.toString());

    if (searchName != null) {
      url = '$url&search=$searchName';
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
}
