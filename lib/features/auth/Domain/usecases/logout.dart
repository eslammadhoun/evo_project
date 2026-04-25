import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/auth/Domain/repositories/auth_reposotory.dart';

class LogoutUsecase {
  final AuthRepository authRepository;
  const LogoutUsecase({required this.authRepository});

  Future<Either<Failure, void>> call() async {
    return authRepository.logout();
  }
}
