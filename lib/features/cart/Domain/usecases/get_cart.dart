import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/domain/repositories/cart_repository.dart';
import 'package:evo_project/features/cart/domain/entities/cart_item.dart';

class GetCartUsecase {
  final CartRepository cartRepository;
  const GetCartUsecase({required this.cartRepository});

  Future<Either<Failure, List<CartItem>>> call() async {
    return await cartRepository.getCart();
  }
}
