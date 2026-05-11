import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/api_endpoints.dart';
import 'package:evo_project/core/network/response_wrapper.dart';

class AuthRemoteDatasource {
  final ApiConsumer apiConsumer;
  AuthRemoteDatasource({required this.apiConsumer});

  Future<ResponseWrapper> signIn({
    required String email,
    required String password,
  }) async {
    return await apiConsumer.post(
      ApiEndpoints.login,
      body: {"email": email, "password": password},
    );
  }

  Future<ResponseWrapper> signUp({
    required String name,
    required String email,
    required String password,
    required String telephone,
    required String telephoneExtension,
    required String dateOfBirth,
  }) async {
    return await apiConsumer.post(
      ApiEndpoints.register,
      body: {
        "name": name,
        "email": email,
        "password": password,
        "telephone_extension": telephoneExtension,
        "telephone": telephone,
        "newsletter": 1,
        "date_of_birth": dateOfBirth,
      },
    );
  }

  Future<ResponseWrapper> logout() async {
    return await apiConsumer.post(ApiEndpoints.logout);
  }

  Future<ResponseWrapper> refreshToken(String token) async {
    return await apiConsumer.post(
      ApiEndpoints.refreshToken,
      body: {'customer_token': token},
    );
  }
}
