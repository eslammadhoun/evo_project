import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/auth/domain/entities/user_entity.dart';
import 'package:evo_project/features/auth/domain/repositories/auth_reposotory.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
