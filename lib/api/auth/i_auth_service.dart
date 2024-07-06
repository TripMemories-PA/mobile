import '../../object/profile.dart';
import 'model/response/auth_success_response.dart';
import 'model/response/subscribe_success_response.dart';

abstract class IAuthService {
  Future<AuthSuccessResponse> login({
    required String email,
    required String password,
  });

  Future<AuthSuccessResponse> refresh();

  Future<SubscribeSuccessResponse> subscribe({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  });

  Future<Profile> whoAmI();

  Future<void> deleteAccount();
}
