import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/core/services/network_logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppInterceptors extends Interceptor {
  final AppPreferences appPreferences;
  final Dio _dio;

  // Flag to prevent infinite retry loops
  bool _isRefreshing = false;

  AppInterceptors({required this.appPreferences, required Dio dio})
    : _dio = dio;

  static const String _refreshTokenEndpoint =
      'https://mcstaging2.femi9.com/rest/V1/ktpl/account/refreshToken';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Content-Type'] = 'application/json';
    options.headers['charset'] = 'utf-8';
    options.headers['Accept'] = 'application/json';
    options.headers['x-secret-key'] = 'application/json';
    options.headers['X-Platform'] = Platform.isAndroid ? 'android' : 'ios';
    options.headers['Accept-Language'] = 'en';

    final token = appPreferences.getToken();
    if (token != null && token.isNotEmpty) {
      debugPrint("Auth Token: $token");
      options.headers["Authorization"] = "Bearer $token";
    }

    NetworkLogger().logRequest(options.method, options.path, options.data);
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    // Handle 401 here since validateStatus accepts it
    if (response.statusCode == 401) {
      // Don't retry logout endpoint
      final isLogoutRequest = response.requestOptions.path.contains('logout');

      if (!isLogoutRequest && !_isRefreshing) {
        _isRefreshing = true;
        final refreshSuccess = await _tryRefreshToken();
        debugPrint('refresh token result: $refreshSuccess');
        _isRefreshing = false;

        if (refreshSuccess) {
          try {
            final newToken = appPreferences.getToken();
            final retryOptions = response.requestOptions;
            retryOptions.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await _dio.fetch(retryOptions);
            return handler.next(retryResponse);
          } catch (_) {
            await _logoutAndRedirect();
            return handler.next(response);
          }
        } else {
          await _logoutAndRedirect();
          return handler.next(response);
        }
      } else {
        // It's a logout request with 401 → just clear locally and redirect
        await _logoutAndRedirect();
        return handler.next(response);
      }
    }
    dynamic logData = response.data;

    if (response.data is String) {
      try {
        final decodedResponse = json.decode(response.data);
        final prettyJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(decodedResponse);
        debugPrint("Response Decoded:\n$prettyJson");
        logData = decodedResponse;
      } catch (e) {
        debugPrint("Failed to decode response: ${response.data}");
      }
    } else if (response.data is Map<String, dynamic>) {
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(response.data);
      debugPrint("Response JSON:\n$prettyJson");
    } else {
      debugPrint("Response Data: ${response.data}");
    }

    NetworkLogger().logResponse(
      response.requestOptions.path,
      response.statusCode ?? 0,
      logData,
    );
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );

    NetworkLogger().logError(
      err.requestOptions.path,
      err.response?.statusCode ?? 0,
      err.message ?? 'Unknown Error',
    );

    super.onError(err, handler);
  }

  /// Returns true if refresh succeeded and new token was saved
  Future<bool> _tryRefreshToken() async {
    try {
      final currentToken = appPreferences.getToken();
      if (currentToken == null || currentToken.isEmpty) return false;

      final response = await Dio().post(
        _refreshTokenEndpoint,
        data: {'customer_token': currentToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Adjust this based on the actual response structure
        final newToken =
            response.data['token'] ??
            response.data['customer_token'] ??
            response.data;

        if (newToken != null && newToken.toString().isNotEmpty) {
          await appPreferences.setToken(newToken.toString());
          debugPrint("Token refreshed successfully");
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint("Token refresh failed: $e");
      return false;
    }
  }

  Future<void> _logoutAndRedirect() async {
    debugPrint("Session expired → logging out");

    await appPreferences.logout();

    // Navigate to signin, removing all previous routes
    final context = sl<GlobalKey<NavigatorState>>().currentContext;
    if (context != null && context.mounted) {
      GoRouter.of(context).goNamed(RouteNames.signin);
    }
  }
}
