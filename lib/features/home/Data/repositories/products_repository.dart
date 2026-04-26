import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/features/home/Data/datasources/products_datasource.dart';
import 'package:evo_project/features/home/Data/mappers/dashboard_mapper.dart';
import 'package:evo_project/features/home/Data/mappers/product_mapper.dart';
import 'package:evo_project/features/home/Data/models/dashboard_model.dart';
import 'package:evo_project/features/home/Data/models/product_model.dart';
import 'package:evo_project/features/home/Domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/Domain/entities/paginated_products.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

class ProductsRepository {
  final ProductsDatasource productsDatasource;
  const ProductsRepository({required this.productsDatasource});

  Future<Either<Failure, DashboardEntity>> getDashboard() async {
    try {
      final ResponseWrapper getDashboardResponse = await productsDatasource
          .getDashboard();
      final DashboardModel dashboardModel = DashboardModel.fromJson(
        getDashboardResponse.data[0],
      );
      return Right(dashboardModel.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, PaginatedProducts>> getCategoryProducts({
    required String catecoryId,
    required int page,
  }) async {
    try {
      final ResponseWrapper getProductsResponse = await productsDatasource
          .getProducts(catecoryId: catecoryId, page: page);
      final data = getProductsResponse.data[0];

      final List<Product> listOfProducts = (data['products'] as List)
          .map((jsonProduct) => ProductModel.fromJson(jsonProduct).toEntity())
          .toList();
      return Right(
        PaginatedProducts(products: listOfProducts, hasMore: data['has_more']),
      );
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
