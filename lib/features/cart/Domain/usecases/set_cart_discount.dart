import 'package:evo_project/features/cart/domain/repositories/cart_repository.dart';

class SetCartDiscount {
  final CartRepository cartRepository;
  const SetCartDiscount({required this.cartRepository});

  Future<void> call({
    required bool userHaveDiscount,
    required double cartDiscount,
  }) async {
    return cartRepository.setCartDiscountState(
      userHaveDiscount: userHaveDiscount,
      cartDiscount: cartDiscount,
    );
  }
}
