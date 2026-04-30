import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/Data/repos/cart_repo.dart';

class DeleteProductFromCart {
  final CartRepository cartRepository;
  const DeleteProductFromCart({required this.cartRepository});

  Future<Either<Failure, void>> call({required String productId}) {
    return cartRepository.deleteCartProduct(productId: productId);
  }
}
