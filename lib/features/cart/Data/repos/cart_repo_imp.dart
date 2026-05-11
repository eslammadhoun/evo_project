import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/errors/repository_error_handler.dart';
import 'package:evo_project/features/cart/data/cart_item_mapper.dart';
import 'package:evo_project/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:evo_project/features/cart/domain/entities/cart_item.dart';

import 'package:evo_project/features/cart/domain/repositories/cart_repository.dart';

class CartRepoImp with RepositoryErrorHandler implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepoImp({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addProductToCart({required CartItem cartItem}) {
    return handleRepositoryCall(() async {
      return await localDataSource.addProductToCart(
        cartItemModel: cartItem.toModel(),
      );
    });
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCart() {
    return handleRepositoryCall(() async {
      final result = await localDataSource.getItems();
      return result.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, void>> updateProductQuantity({
    required bool increment,
    required String productId,
  }) {
    return handleRepositoryCall(() async {
      return await localDataSource.updateProductQuantity(
        increment: increment,
        productId: productId,
      );
    });
  }

  @override
  Future<Either<Failure, void>> deleteCartProduct({required String productId}) {
    return handleRepositoryCall(() async {
      return await localDataSource.deleteItem(productId);
    });
  }

  @override
  Future<void> setCartDiscountState({
    required bool userHaveDiscount,
    required double cartDiscount,
  }) async {
    await localDataSource.setCartDiscountState(
      userHaveDiscount: userHaveDiscount,
      cartDiscount: cartDiscount,
    );
  }

  @override
  Future<Map<String, dynamic>> getCartDiscountState() async {
    return await localDataSource.getDiscountState();
  }
}
