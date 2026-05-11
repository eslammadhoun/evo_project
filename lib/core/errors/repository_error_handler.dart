import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';

mixin RepositoryErrorHandler {
  Future<Either<Failure, T>> handleRepositoryCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      // Centeralized mapping of unknown exceptions to a generic user-friendly message
      // This prevents leaking technical details like "TypeError" or "FormatException"
      return Left(ServerFailure('Something went wrong on our end. Please try again later.'));
    }
  }
}
