import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/Data/repos/cart_repo.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';

class AddProductToCart {
  final CartRepository cartRepository;
  const AddProductToCart({required this.cartRepository});

  Future<Either<Failure, void>> call({required CartItem cartItem}) {
    return cartRepository.addProductToCart(cartItem: cartItem);
  }
}
