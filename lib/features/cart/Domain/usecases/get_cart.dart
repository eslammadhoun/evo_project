import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/Data/repos/cart_repo.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';

class GetCartUsecase {
  final CartRepository cartRepository;
  const GetCartUsecase({required this.cartRepository});

  Future<Either<Failure, List<CartItem>>> call() async {
    return await cartRepository.getCart();
  }
}
