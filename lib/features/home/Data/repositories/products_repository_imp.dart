import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/errors/repository_error_handler.dart';
import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/features/home/data/datasources/products_datasource.dart';
import 'package:evo_project/features/home/data/mappers/dashboard_mapper.dart';
import 'package:evo_project/features/home/data/mappers/product_mapper.dart';
import 'package:evo_project/features/home/data/models/dashboard_model.dart';
import 'package:evo_project/features/home/data/models/product_model.dart';
import 'package:evo_project/features/home/domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/domain/entities/paginated_products.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';

import 'package:evo_project/features/home/domain/repositories/products_repository.dart';

class ProductsRepositoryImp with RepositoryErrorHandler implements ProductsRepository {
  final ProductsDatasource productsDatasource;
  const ProductsRepositoryImp({required this.productsDatasource});

  Future<Either<Failure, DashboardEntity>> getDashboard() {
    return handleRepositoryCall(() async {
      final ResponseWrapper response = await productsDatasource.getDashboard();
      final DashboardModel model = DashboardModel.fromJson(response.data[0]);
      return model.toEntity();
    });
  }

  Future<Either<Failure, PaginatedProducts>> getCategoryProducts({
    required String categoryId,
    required int page,
  }) {
    return handleRepositoryCall(() async {
      final ResponseWrapper response = await productsDatasource.getProducts(
        categoryId: categoryId,
        page: page,
      );
      final data = response.data[0];
      final List<Product> products = (data['products'] as List)
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();
      return PaginatedProducts(products: products, hasMore: data['has_more']);
    });
  }

  Future<Either<Failure, Product>> getProduct({required String productId}) {
    return handleRepositoryCall(() async {
      final ResponseWrapper response = await productsDatasource.getProduct(productId: productId);
      return ProductModel.fromJson(response.data[0]).toEntity();
    });
  }

  Future<Either<Failure, List<Product>>> getMostRelatedProducts({required String productId}) {
    return handleRepositoryCall(() async {
      final ResponseWrapper response = await productsDatasource.getRelatedProducts(productId: productId);
      final List<dynamic> jsonList = response.data;
      return jsonList
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();
    });
  }
}
