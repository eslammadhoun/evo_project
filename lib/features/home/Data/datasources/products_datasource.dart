import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/api_endpoints.dart';
import 'package:evo_project/core/network/response_wrapper.dart';

class ProductsDatasource {
  final ApiConsumer apiClient;
  const ProductsDatasource({required this.apiClient});

  Future<ResponseWrapper> getProducts({required String catecoryId}) async {
    final ResponseWrapper getProductsResponse = await apiClient.get(
      ApiEndpoints.products,
      queryParameters: {'category_id': catecoryId},
    );

    if (getProductsResponse.statusModel.error >= 1) {
      throw ServerFailure(
        getProductsResponse.statusModel.errorMessages
            .map((error) => error)
            .toString(),
      );
    }
    return getProductsResponse;
  }

  Future<ResponseWrapper> getProduct({required String productId}) async {
    final ResponseWrapper getProductResponse = await apiClient.get(
      ApiEndpoints.productDetails,
      queryParameters: {'product_id': productId},
    );

    if (getProductResponse.statusModel.code == 1) {
      throw ServerFailure(getProductResponse.statusModel.errorMessages[0]);
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
    if (getRelatedProductsReponse.statusModel.code == 1) {
      throw ServerFailure(
        getRelatedProductsReponse.statusModel.errorMessages[0],
      );
    }

    return getRelatedProductsReponse;
  }
}
