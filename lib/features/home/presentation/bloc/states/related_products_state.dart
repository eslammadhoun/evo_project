import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

enum GetRelatedProductsStates { initial, loading, success, failure }

class RelatedProductsState extends Equatable {
  // ====================== Get Related Products States ======================
  final GetRelatedProductsStates getRelatedProductsState;
  final String? getRelatedProductsErrorMessage;
  final List<Product>? relatedProducts;

  const RelatedProductsState({
    required this.getRelatedProductsState,
    this.getRelatedProductsErrorMessage,
    this.relatedProducts,
  });
  // ==========================================================================

  factory RelatedProductsState.initial() {
    return RelatedProductsState(
      getRelatedProductsState: GetRelatedProductsStates.initial,
      relatedProducts: [],
    );
  }

  RelatedProductsState copyWith({
    GetRelatedProductsStates? getRelatedProductsState,
    String? getRelatedProductsErrorMessage,
    List<Product>? relatedProducts,
  }) {
    return RelatedProductsState(
      getRelatedProductsState:
          getRelatedProductsState ?? this.getRelatedProductsState,
      getRelatedProductsErrorMessage:
          getRelatedProductsErrorMessage ?? this.getRelatedProductsErrorMessage,
      relatedProducts: relatedProducts ?? this.relatedProducts,
    );
  }

  @override
  List<Object?> get props => [
    getRelatedProductsState,
    getRelatedProductsErrorMessage,
    relatedProducts,
  ];
}
