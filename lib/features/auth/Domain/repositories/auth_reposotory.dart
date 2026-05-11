import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String telephone,
    required String telephoneExtension,
    required String dateOfBirth,
  });

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> refreshToken();
}
