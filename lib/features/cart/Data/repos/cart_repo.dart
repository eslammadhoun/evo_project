import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/cart/Data/cart_item_mapper.dart';
import 'package:evo_project/features/cart/Data/datasources/cart_local_datasource.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';

class CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepository({required this.localDataSource});

  // CREATE
  Future<Either<Failure, void>> addProductToCart({
    required CartItem cartItem,
  }) async {
    try {
      return Right(
        await localDataSource.addProductToCart(
          cartItemModel: cartItem.toModel(),
        ),
      );
    } catch (e) {
      if (e is Failure) {
        return Left(CacheFailure(e.message));
      }
      return Left(Failure(e.toString()));
    }
  }

  // READ
  Future<Either<Failure, List<CartItem>>> getCart() async {
    try {
      final result = await localDataSource.getItems();
      return Right(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is Failure) {
        return Left(CacheFailure(e.message));
      }
      return Left(CacheFailure(e.toString()));
    }
  }

  // UPDATE
  Future<Either<Failure, void>> updateProductQuantity({
    required bool increment,
    required String productId,
  }) async {
    try {
      return Right(
        await localDataSource.updateProductQuantity(
          increment: increment,
          productId: productId,
        ),
      );
    } catch (e) {
      if (e is Failure) {
        return Left(CacheFailure(e.message));
      }
      return Left(CacheFailure(e.toString()));
    }
  }

  // DELETE
  Future<Either<Failure, void>> deleteCartProduct({
    required String productId,
  }) async {
    try {
      return Right(await localDataSource.deleteItem(productId));
    } catch (e) {
      if (e is Failure) {
        return Left(CacheFailure(e.message));
      }
      return Left(CacheFailure(e.toString()));
    }
  }
}
