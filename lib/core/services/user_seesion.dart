import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/api_endpoints.dart';
import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/features/auth/Data/models/user_model.dart';

class UserSeesion {
  final ApiConsumer apiConsumer;
  final AppPreferences appPreferences;
  UserSeesion({required this.apiConsumer, required this.appPreferences});

  Future<ResponseWrapper> signIn({
    required String email,
    required String password,
  }) async {
    final ResponseWrapper loginResponse = await apiConsumer.post(
      ApiEndpoints.login,
      body: {"email": email, "password": password},
    );

    if (loginResponse.statusModel.error == 1) {
      throw ServerFailure(loginResponse.statusModel.errorMessages.first);
    }

    final UserModel userModel = UserModel.fromJson(loginResponse.data[0]);
    await appPreferences.setToken(userModel.customerToken);
    await appPreferences.setAuthenticated(true);
    await appPreferences.setUserEmail(userModel.email);
    await appPreferences.setUserName(userModel.name);
    return loginResponse;
  }

  Future<ResponseWrapper> logout({required String customerToken}) async {
    final ResponseWrapper logoutResponse = await apiConsumer.post(
      ApiEndpoints.logout,
    );
    if (logoutResponse.statusModel.error == 1) {
      throw ServerFailure(logoutResponse.statusModel.message);
    }
    await appPreferences.logout();
    return logoutResponse;
  }
}
