import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';

enum GetCategoryStates { initial, loading, success, failure }

class CategoryState extends Equatable {
  final GetCategoryStates getCategoryState;
  final String? getCategoryErrorMessage;
  final List<Product> categoryProducts;
  final int page;
  final bool hasMore;

  const CategoryState({
    required this.getCategoryState,
    this.getCategoryErrorMessage,
    required this.categoryProducts,
    this.page = 1,
    this.hasMore = true,
  });

  factory CategoryState.initial() {
    return const CategoryState(
      getCategoryState: GetCategoryStates.initial,
      categoryProducts: [],
      page: 1,
      hasMore: true,
    );
  }

  CategoryState copyWith({
    GetCategoryStates? getCategoryState,
    String? getCategoryErrorMessage,
    List<Product>? categoryProducts,
    int? page,
    bool? hasMore,
  }) {
    return CategoryState(
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
