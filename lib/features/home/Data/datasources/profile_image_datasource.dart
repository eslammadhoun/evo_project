import 'dart:io';
import 'package:dio/dio.dart';
import 'package:evo_project/core/env_config.dart';

class ProfileImageDatasource {
  final Dio dioClient;

  const ProfileImageDatasource({required this.dioClient});

  Future<void> uploadProfileImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        "key": EnvConfig.imageApiKey,
        "action": "upload",
        "source": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await dioClient.post(
        "https://freeimage.host/api/1/upload",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('response data: $data');

        if (data["status_code"] == 200) {
          final imageUrl = data["image"]["url"];
          return imageUrl;
        } else {
          throw Exception("Upload failed: ${data["status_txt"]}");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // 🔴 أخطاء Dio (Network / Timeout / Server)
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Receive timeout");
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception("Bad response: ${e.response?.statusCode}");
      } else if (e.type == DioExceptionType.cancel) {
        throw Exception("Request cancelled");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      // 🔴 أي خطأ غير متوقع
      throw Exception("Unexpected error: $e");
    }
  }
}
