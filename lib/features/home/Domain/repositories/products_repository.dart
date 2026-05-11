import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/domain/entities/paginated_products.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<Either<Failure, DashboardEntity>> getDashboard();
  Future<Either<Failure, PaginatedProducts>> getCategoryProducts({
    required String categoryId,
    required int page,
  });
  Future<Either<Failure, Product>> getProduct({required String productId});
  Future<Either<Failure, List<Product>>> getMostRelatedProducts({required String productId});
}
