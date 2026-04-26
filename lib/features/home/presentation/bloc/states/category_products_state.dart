import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

enum GetCategoryStates { initial, loading, success, failure }

class CategoryProductsState extends Equatable {
  // ====================== Get Catecory Products States ======================
  final GetCategoryStates getCategoryState;
  final String? getCategoryErrorMessage;
  final List<Product>? categoryProducts;
  final int page;
  final bool hasMore;

  // ==========================================================================

  const CategoryProductsState({
    required this.getCategoryState,
    this.getCategoryErrorMessage,
    this.categoryProducts,
    this.page = 1,
    this.hasMore = true,
  });

  factory CategoryProductsState.inital() {
    return CategoryProductsState(
      getCategoryState: GetCategoryStates.initial,
      categoryProducts: [],
      page: 1,
      hasMore: true,
    );
  }

  CategoryProductsState copyWith({
    GetCategoryStates? getCategoryState,
    String? getCategoryErrorMessage,
    List<Product>? categoryProducts,
    int? page,
    bool? hasMore,
  }) {
    return CategoryProductsState(
      getCategoryState: getCategoryState ?? this.getCategoryState,
      getCategoryErrorMessage:
          getCategoryErrorMessage ?? this.getCategoryErrorMessage,
      categoryProducts: categoryProducts ?? this.categoryProducts,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    getCategoryState,
    getCategoryErrorMessage,
    categoryProducts,
    page,
    hasMore,
  ];
}
