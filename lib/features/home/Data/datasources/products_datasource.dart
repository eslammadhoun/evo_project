import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/api_endpoints.dart';
import 'package:evo_project/core/network/response_wrapper.dart';

class ProductsDatasource {
  final ApiConsumer apiClient;
  const ProductsDatasource({required this.apiClient});

  Future<ResponseWrapper> getDashboard() async {
    final ResponseWrapper getDashboardResponse = await apiClient.get(
      ApiEndpoints.dashboard,
    );
    if (getDashboardResponse.statusModel.error == 1) {
      throw ServerFailure(
        getDashboardResponse.statusModel.errorMessages.join(', '),
      );
    }

    return getDashboardResponse;
  }

  Future<ResponseWrapper> getProducts({
    required String categoryId,
    required int page,
  }) async {
    final ResponseWrapper getProductsResponse = await apiClient.get(
      ApiEndpoints.products,
      queryParameters: {'category_id': categoryId, 'page': page},
    );

    if (getProductsResponse.statusModel.error == 1) {
      throw ServerFailure(
        getProductsResponse.statusModel.errorMessages.join(', '),
      );
    }
    return getProductsResponse;
  }

  Future<ResponseWrapper> getProduct({required String productId}) async {
    final ResponseWrapper getProductResponse = await apiClient.get(
      ApiEndpoints.productDetails,
      queryParameters: {'product_id': productId},
    );

    if (getProductResponse.statusModel.error == 1) {
      throw ServerFailure(getProductResponse.statusModel.errorMessages.first);
    }
    return getProductResponse;
  }

  Future<ResponseWrapper> getRelatedProducts({
    required String productId,
  }) async {
    final ResponseWrapper getRelatedProductsReponse = await apiClient.get(
      ApiEndpoints.relatedProducts,
      queryParameters: {'prod_id': productId},
    );
    if (getRelatedProductsReponse.statusModel.error == 1) {
      throw ServerFailure(
        getRelatedProductsReponse.statusModel.errorMessages.first,
      );
    }

    return getRelatedProductsReponse;
  }
}
