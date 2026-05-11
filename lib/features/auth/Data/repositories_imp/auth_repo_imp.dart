import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/errors/repository_error_handler.dart';
import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:evo_project/features/auth/data/mappers/user_mapper.dart';
import 'package:evo_project/features/auth/data/models/user_model.dart';
import 'package:evo_project/features/auth/domain/entities/user_entity.dart';
import 'package:evo_project/features/auth/domain/repositories/auth_reposotory.dart';

class AuthRepoImp with RepositoryErrorHandler implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final AppPreferences appPreferences;
  const AuthRepoImp({
    required this.authRemoteDatasource,
    required this.appPreferences,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) {
    return handleRepositoryCall(() async {
      final ResponseWrapper response = await authRemoteDatasource.signIn(
        email: email,
        password: password,
      );

      if (response.statusModel.error == 1) {
        throw ServerFailure(response.statusModel.errorMessages.first);
      }

      final UserModel model = UserModel.fromJson(response.data[0]);

      // Save user data to preferences
      await appPreferences.setToken(model.customerToken);
      await appPreferences.setAuthenticated(true);
      await appPreferences.setUserEmail(model.email);
      await appPreferences.setUserName(model.name);

      return UserMapper.toUserEntity(userModel: model);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String telephone,
    required String telephoneExtension,
    required String dateOfBirth,
  }) {
    return handleRepositoryCall(() async {
      final ResponseWrapper response = await authRemoteDatasource.signUp(
        name: name,
        email: email,
        password: password,
        telephone: telephone,
        telephoneExtension: telephoneExtension,
        dateOfBirth: dateOfBirth,
      );

      if (response.statusModel.error == 1) {
        throw ServerFailure(response.statusModel.errorMessages.first);
      }

      final UserModel model = UserModel.fromJson(response.data[0]);

      // Save user data to preferences
      await appPreferences.setToken(model.customerToken);
      await appPreferences.setAuthenticated(true);
      await appPreferences.setUserEmail(model.email);
      await appPreferences.setUserName(model.name);

      return UserMapper.toUserEntity(userModel: model);
    });
  }

  @override
  Future<Either<Failure, void>> logout() {
    return handleRepositoryCall(() async {
      final ResponseWrapper response = await authRemoteDatasource.logout();

      if (response.statusModel.error == 1) {
        throw ServerFailure(response.statusModel.message);
      }

      await appPreferences.logout();
    });
  }

  @override
  Future<Either<Failure, bool>> refreshToken() {
    return handleRepositoryCall(() async {
      final token = appPreferences.getToken();

      if (token == null || token.isEmpty) return false;

      final ResponseWrapper response = await authRemoteDatasource.refreshToken(token);

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
    });
  }
}
