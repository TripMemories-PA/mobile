import 'model/response/auth_success_response/auth_success_response.dart';
import 'model/response/subscribe_success_response/subscribe_success_response.dart';
import 'model/response/who_am_i_response/who_am_i_response.dart';

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

  Future<WhoAmIResponse> whoAmI();

  Future<void> deleteAccount();
}
