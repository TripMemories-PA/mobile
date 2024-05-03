import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.config.dart';
import '../../object/avatar/avatar.dart';
import '../../object/profile/profile.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_profile_service.dart';
import 'response/friends/get_friends_pagination_response.dart';

class ProfileService implements IProfileService {
  static const String apiProfileUrl = '${AppConfig.apiUrl}/me';
  static const String apiAvatarUrl = '$apiProfileUrl/avatar';
  static const String apiFriendsUrl =
      '$apiProfileUrl/friends?page=[nb_page]&perPage=[per_page]';

  @override
  Future<Profile> getProfile({required String id}) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        apiProfileUrl,
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
      apiProfileUrl,
      data: {
        'username': username,
        'lastname': lastName,
        'firstname': firstName,
        'email': email,
      },
    );
  }

  @override
  Future<GetFriendsPaginationResponse> getFriends({
    required String id,
    required int page,
    required int perPage,
  }) async {
    Response response;
    final String url = apiFriendsUrl
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
  Future<UploadFile> updateProfilePicture({
    required XFile image,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        apiAvatarUrl,
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
}
