import 'package:evo_project/features/cart/Data/datasources/cart_local_datasource.dart';

class SetCartDiscount {
  final CartLocalDataSource cartLocalDataSource;
  const SetCartDiscount({required this.cartLocalDataSource});

  Future<void> call({
    required bool userHaveDiscount,
    required double cartDiscount,
  }) async {
    return cartLocalDataSource.setCartDiscountState(
      userHaveDiscount: userHaveDiscount,
      cartDiscount: cartDiscount,
    );
  }
}
