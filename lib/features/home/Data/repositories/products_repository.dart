import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/features/home/Data/datasources/products_datasource.dart';
import 'package:evo_project/features/home/Data/mappers/product_mapper.dart';
import 'package:evo_project/features/home/Data/models/product_model.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

class ProductsRepository {
  final ProductsDatasource productsDatasource;
  const ProductsRepository({required this.productsDatasource});

  Future<Either<Failure, List<Product>>> getCategoryProducts({
    required String catecoryId,
  }) async {
    try {
      final ResponseWrapper getProductsResponse = await productsDatasource
          .getProducts(catecoryId: catecoryId);
      final List<dynamic> jsonResponse =
          getProductsResponse.data[0]['products'];

      final List<Product> listOfProducts = jsonResponse
          .map((jsonProduct) => ProductModel.fromJson(jsonProduct).toEntity())
          .toList();
      return Right(listOfProducts);
    } catch (e) {
      if (e is Failure) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure('Un Known Error: ${e.toString()}'));
    }
  }

  Future<Either<Failure, Product>> getProduct({
    required String productId,
  }) async {
    try {
      final ResponseWrapper getProductResponse = await productsDatasource
          .getProduct(productId: productId);
      final Product product = ProductModel.fromJson(
        getProductResponse.data[0],
      ).toEntity();
      return Right(product);
    } catch (e) {
      if (e is Failure) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure('Un Known Error: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<Product>>> getMostRelatedProducts({
    required String productId,
  }) async {
    try {
      final ResponseWrapper getProductsResponse = await productsDatasource
          .getRelatedProducts(productId: productId);
      final List<dynamic> jsonResponse = getProductsResponse.data;

      final List<Product> listOfProducts = jsonResponse
          .map(
            (jsonProduct) => ProductModel.fromJson(
              jsonProduct as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
      return Right(listOfProducts);
    } catch (e) {
      if (e is Failure) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure('Un Known Error: ${e.toString()}'));
    }
  }
}
