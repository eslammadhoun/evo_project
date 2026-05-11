import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/domain/repositories/products_repository.dart';
import 'package:evo_project/features/home/domain/entities/paginated_products.dart';

class GetCategoryUsecase {
  final ProductsRepository productsRepository;
  const GetCategoryUsecase({required this.productsRepository});

  Future<Either<Failure, PaginatedProducts>> call({
    required String categoryId,
    required int page,
  }) {
    return productsRepository.getCategoryProducts(
      categoryId: categoryId,
      page: page,
    );
  }
}
