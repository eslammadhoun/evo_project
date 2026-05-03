import 'package:dartz/dartz.dart';
import 'package:evo_project/core/Database/app_database.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/auth/Domain/repositories/auth_reposotory.dart';

class LogoutUsecase {
  final AuthRepository authRepository;
  final AppDatabase appDatabase;
  const LogoutUsecase({
    required this.authRepository,
    required this.appDatabase,
  });

  Future<Either<Failure, void>> call() async {
    await appDatabase.deleteAllDatabasse();
    return authRepository.logout();
  }
}
