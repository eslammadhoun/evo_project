import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/features/auth/Data/data_sources/auth_remote_datasource.dart';
import 'package:evo_project/features/auth/Data/mappers/user_mapper.dart';
import 'package:evo_project/features/auth/Data/models/user_model.dart';
import 'package:evo_project/features/auth/Domain/entites/user_entity.dart';
import 'package:evo_project/features/auth/Domain/repositories/auth_reposotory.dart';

class AuthRepoImp implements AuthRepository {
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
  }) async {
    try {
      final ResponseWrapper loginResponse = await authRemoteDatasource.signIn(
        email: email,
        password: password,
      );
      final UserModel userModel = UserModel.fromJson(loginResponse.data[0]);
      final UserEntity user = UserMapper.toUserEntity(userModel: userModel);
      return Right(user);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResponseWrapper>> logout() async {
    try {
      final String? customerToken = appPreferences.getToken();

      if (customerToken == null) {
        return Left(ServerFailure('User Not Authenticated'));
      }
      final ResponseWrapper logoutResponse = await authRemoteDatasource.logout(
        customerToken: customerToken,
      );
      return Right(logoutResponse);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
