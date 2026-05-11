import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/domain/repositories/cart_repository.dart';
import 'package:evo_project/features/cart/domain/entities/cart_item.dart';

class AddProductToCart {
  final CartRepository cartRepository;
  const AddProductToCart({required this.cartRepository});

  Future<Either<Failure, void>> call({required CartItem cartItem}) {
    return cartRepository.addProductToCart(cartItem: cartItem);
  }
}
