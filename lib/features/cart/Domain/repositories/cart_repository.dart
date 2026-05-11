import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, void>> addProductToCart({required CartItem cartItem});
  Future<Either<Failure, List<CartItem>>> getCart();
  Future<Either<Failure, void>> updateProductQuantity({
    required bool increment,
    required String productId,
  });
  Future<Either<Failure, void>> deleteCartProduct({required String productId});
  Future<void> setCartDiscountState({
    required bool userHaveDiscount,
    required double cartDiscount,
  });
  Future<Map<String, dynamic>> getCartDiscountState();
}
