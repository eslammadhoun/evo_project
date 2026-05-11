import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/domain/repositories/cart_repository.dart';

class UpdateProductQuantity {
  final CartRepository cartRepository;
  const UpdateProductQuantity({required this.cartRepository});

  Future<Either<Failure, void>> call({
    required bool increment,
    required String productId,
  }) async {
    return cartRepository.updateProductQuantity(
      increment: increment,
      productId: productId,
    );
  }
}
