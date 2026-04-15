import 'package:dio/dio.dart';
import 'app_logger.dart';

class LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info("REQUEST → ${options.method} ${options.path}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info("RESPONSE ← ${response.statusCode}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      "ERROR ❌ ${err.message}",
      error: err,
      stackTrace: err.stackTrace,
    );
    super.onError(err, handler);
  }
}
