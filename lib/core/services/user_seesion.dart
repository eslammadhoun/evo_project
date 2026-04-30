import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/api_endpoints.dart';
import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/features/auth/Data/models/user_model.dart';
import 'package:flutter/material.dart';

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

  Future<bool> refreshToken() async {
    try {
      final token = appPreferences.getToken();

      if (token == null || token.isEmpty) return false;

      final ResponseWrapper response = await apiConsumer.post(
        ApiEndpoints.refreshToken,
        body: {'customer_token': token},
      );

      if (response.statusModel.error == 0 && response.data != null) {
        final newToken =
            response.data[0]['token'] ??
            response.data[0]['customer_token'] ??
            response.data;

        if (newToken != null && newToken.toString().isNotEmpty) {
          await appPreferences.setToken(newToken.toString());
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint("Refresh Token Error: $e");
      return false;
    }
  }
}
