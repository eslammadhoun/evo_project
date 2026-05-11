import 'package:evo_project/features/cart/domain/repositories/cart_repository.dart';

class GetCartDiscountState {
  final CartRepository cartRepository;
  const GetCartDiscountState({required this.cartRepository});

  Future<Map<String, dynamic>> call() async {
    return await cartRepository.getCartDiscountState();
  }
}
