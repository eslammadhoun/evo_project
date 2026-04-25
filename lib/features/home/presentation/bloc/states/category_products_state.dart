import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

enum GetCategoryStates { initial, loading, success, failure }

class CategoryProductsState extends Equatable {
  // ====================== Get Catecory Products States ======================
  final GetCategoryStates getCategoryState;
  final String? getCategoryErrorMessage;
  final List<Product>? categoryProducts;
  // ==========================================================================

  const CategoryProductsState({
    required this.getCategoryState,
    this.getCategoryErrorMessage,
    this.categoryProducts,
  });

  factory CategoryProductsState.inital() {
    return CategoryProductsState(
      getCategoryState: GetCategoryStates.initial,
      categoryProducts: [],
    );
  }

  CategoryProductsState copyWith({
    GetCategoryStates? getCategoryState,
    String? getCategoryErrorMessage,
    List<Product>? categoryProducts,
  }) {
    return CategoryProductsState(
      getCategoryState: getCategoryState ?? this.getCategoryState,
      getCategoryErrorMessage:
          getCategoryErrorMessage ?? this.getCategoryErrorMessage,
      categoryProducts: categoryProducts ?? this.categoryProducts,
    );
  }

  @override
  List<Object?> get props => [
    getCategoryState,
    getCategoryErrorMessage,
    categoryProducts,
  ];
}
