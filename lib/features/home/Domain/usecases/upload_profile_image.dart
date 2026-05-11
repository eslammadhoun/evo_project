import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/data/datasources/profile_image_datasource.dart';

class UploadProfileImageUsecase {
  final ProfileImageDatasource profileImageDatasource;
  const UploadProfileImageUsecase({required this.profileImageDatasource});

  Future<Either<Failure, void>> call({required File imageFile}) async {
    try {
      return Right(await profileImageDatasource.uploadProfileImage(imageFile));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
