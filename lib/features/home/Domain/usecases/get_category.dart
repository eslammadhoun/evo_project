import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/Data/repositories/products_repository.dart';
import 'package:evo_project/features/home/Domain/entities/paginated_products.dart';

class GetCategoryUsecase {
  final ProductsRepository productsRepository;
  const GetCategoryUsecase({required this.productsRepository});

  Future<Either<Failure, PaginatedProducts>> call({
    required String catecoryId,
    required int page,
  }) {
    return productsRepository.getCategoryProducts(
      catecoryId: catecoryId,
      page: page,
    );
  }
}
