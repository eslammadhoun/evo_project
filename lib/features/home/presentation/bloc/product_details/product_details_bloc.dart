import 'package:evo_project/core/helpers/bloc_request_handler.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';
import 'package:evo_project/features/home/domain/usecases/get_product.dart';
import 'package:evo_project/features/home/domain/usecases/get_related_products.dart';
import 'package:evo_project/features/home/presentation/bloc/product_details/product_details_event.dart';
import 'package:evo_project/features/home/presentation/bloc/product_details/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductUsecase getProductUsecase;
  final GetRelatedProducts getRelatedProductsUsecase;

  ProductDetailsBloc({
    required this.getProductUsecase,
    required this.getRelatedProductsUsecase,
  }) : super(ProductDetailsState.initial()) {
    on<GetProductEvent>(_getProductDetails);
    on<GetRelatedProductsEvent>(_onGetRelatedProducts);
  }

  Future<void> _getProductDetails(
    GetProductEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    await blocRequestHandler<Product>(
      request: () => getProductUsecase(productId: event.productId),
      onLoading: () => emit(
        state.copyWith(getProductDetailsState: GetProductDetails.loading),
      ),
      onSuccess: (product) {
        emit(
          state.copyWith(
            getProductDetailsState: GetProductDetails.success,
            product: product,
          ),
        );
      },
      onError: (message) {
        emit(
          state.copyWith(
            getProductDetailsState: GetProductDetails.failure,
            getProductDetailsErrorMessage: message,
          ),
        );
      },
    );
  }

  Future<void> _onGetRelatedProducts(
    GetRelatedProductsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    await blocRequestHandler<List<Product>>(
      request: () => getRelatedProductsUsecase(productId: event.productId),
      onLoading: () => emit(
        state.copyWith(
          getRelatedProductsState: GetRelatedProductsStates.loading,
        ),
      ),
      onSuccess: (listOfProducts) => emit(
        state.copyWith(
          getRelatedProductsState: GetRelatedProductsStates.success,
          relatedProducts: listOfProducts,
        ),
      ),
      onError: (errorMessage) => emit(
        state.copyWith(
          getRelatedProductsState: GetRelatedProductsStates.failure,
          getRelatedProductsErrorMessage: errorMessage,
        ),
      ),
    );
  }
}
