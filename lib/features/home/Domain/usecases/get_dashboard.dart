import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/domain/repositories/products_repository.dart';
import 'package:evo_project/features/home/domain/entities/dashboard_entity.dart';

class GetDashboardUsecase {
  final ProductsRepository productsRepository;
  const GetDashboardUsecase({required this.productsRepository});

  Future<Either<Failure, DashboardEntity>> call() async {
    return productsRepository.getDashboard();
  }
}
