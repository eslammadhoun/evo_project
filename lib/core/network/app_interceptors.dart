import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/core/services/auth_signals.dart';
import 'package:evo_project/core/services/network_logger.dart';
import 'package:flutter/material.dart';

class AppInterceptors extends Interceptor {
  final AppPreferences appPreferences;

  AppInterceptors({required this.appPreferences});
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
    }
    // إذا كان الرد JSON
    else if (response.data is Map<String, dynamic>) {
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
    if (err.response?.statusCode == 401) {
      AuthSignals.triggerLogout();
    }
    super.onError(err, handler);
  }
}
