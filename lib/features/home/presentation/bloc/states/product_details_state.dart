import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

enum GetProductDetails { initial, loading, success, failure }

class ProductDetailsState extends Equatable {
  // ====================== Get Product Details States ======================
  final GetProductDetails getProductDetailsState;
  final String? getProductDetailsErrorMessage;
  final Product? product;
  // ==========================================================================

  const ProductDetailsState({
    required this.getProductDetailsState,
    this.getProductDetailsErrorMessage,
    this.product,
  });

  factory ProductDetailsState.inital() {
    return ProductDetailsState(
      getProductDetailsState: GetProductDetails.initial,
    );
  }

  ProductDetailsState copyWith({
    GetProductDetails? getProductDetailsState,
    String? getProductDetailsErrorMessage,
    Product? product,
  }) {
    return ProductDetailsState(
      getProductDetailsState:
          getProductDetailsState ?? this.getProductDetailsState,
      getProductDetailsErrorMessage:
          getProductDetailsErrorMessage ?? this.getProductDetailsErrorMessage,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [
    getProductDetailsState,
    getProductDetailsErrorMessage,
    product,
  ];
}
