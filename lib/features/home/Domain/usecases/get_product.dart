import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/Data/repositories/products_repository.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

class GetProductUsecase {
  final ProductsRepository productsRepository;
  const GetProductUsecase({required this.productsRepository});

  Future<Either<Failure, Product>> call({required String productId}) async {
    return productsRepository.getProduct(productId: productId);
  }
}
