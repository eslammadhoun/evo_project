import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';

Future<void> blocRequestHandeler<T>({
  required Future<Either<Failure, T>> Function() request,
  required Function() onLoading,
  required Function(T data) onSuccess,
  required Function(String message) onError,
}) async {
  onLoading();

  final result = await request();

  result.fold(
    (failure) => onError(failure.message),
    (success) => onSuccess(success),
  );
}
