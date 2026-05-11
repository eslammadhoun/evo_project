import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/auth/domain/entities/user_entity.dart';
import 'package:evo_project/features/auth/domain/repositories/auth_reposotory.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
    required String telephone,
    required String telephoneExtension,
    required String dateOfBirth,
  }) {
    return repository.register(
      name: name,
      email: email,
      password: password,
      telephone: telephone,
      telephoneExtension: telephoneExtension,
      dateOfBirth: dateOfBirth,
    );
  }
}
