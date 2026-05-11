import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';

enum GetProductDetails { initial, loading, success, failure }
enum GetRelatedProductsStates { initial, loading, success, failure }

class ProductDetailsState extends Equatable {
  final GetProductDetails getProductDetailsState;
  final String? getProductDetailsErrorMessage;
  final Product? product;

  final GetRelatedProductsStates getRelatedProductsState;
  final String? getRelatedProductsErrorMessage;
  final List<Product> relatedProducts;

  const ProductDetailsState({
    required this.getProductDetailsState,
    this.getProductDetailsErrorMessage,
    this.product,
    required this.getRelatedProductsState,
    this.getRelatedProductsErrorMessage,
    required this.relatedProducts,
  });

  factory ProductDetailsState.initial() {
    return const ProductDetailsState(
      getProductDetailsState: GetProductDetails.initial,
      getRelatedProductsState: GetRelatedProductsStates.initial,
      relatedProducts: [],
    );
  }

  ProductDetailsState copyWith({
    GetProductDetails? getProductDetailsState,
    String? getProductDetailsErrorMessage,
    Product? product,
    GetRelatedProductsStates? getRelatedProductsState,
    String? getRelatedProductsErrorMessage,
    List<Product>? relatedProducts,
  }) {
    return ProductDetailsState(
      getProductDetailsState:
          getProductDetailsState ?? this.getProductDetailsState,
      getProductDetailsErrorMessage:
          getProductDetailsErrorMessage ?? this.getProductDetailsErrorMessage,
      product: product ?? this.product,
      getRelatedProductsState:
          getRelatedProductsState ?? this.getRelatedProductsState,
      getRelatedProductsErrorMessage:
          getRelatedProductsErrorMessage ?? this.getRelatedProductsErrorMessage,
      relatedProducts: relatedProducts ?? this.relatedProducts,
    );
  }

  @override
  List<Object?> get props => [
        getProductDetailsState,
        getProductDetailsErrorMessage,
        product,
        getRelatedProductsState,
        getRelatedProductsErrorMessage,
        relatedProducts,
      ];
}
