import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/domain/repositories/products_repository.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';

class GetRelatedProducts {
  final ProductsRepository productsRepository;
  const GetRelatedProducts({required this.productsRepository});

  Future<Either<Failure, List<Product>>> call({required String productId}) {
    return productsRepository.getMostRelatedProducts(productId: productId);
  }
}
