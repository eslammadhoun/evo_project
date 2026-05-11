import 'package:evo_project/core/helpers/bloc_request_handler.dart';
import 'package:evo_project/features/home/domain/entities/paginated_products.dart';
import 'package:evo_project/features/home/domain/usecases/get_category.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_event.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryUsecase getProductsUsecase;

  CategoryBloc({
    required this.getProductsUsecase,
  }) : super(CategoryState.initial()) {
    on<GetCategoryProductsEvent>(_getCategoryProducts);
    on<LoadMoreCategoryProductsEvent>(_onLoadMoreCategoryProducts);
  }

  Future<void> _getCategoryProducts(
    GetCategoryProductsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    await blocRequestHandler<PaginatedProducts>(
      request: () => getProductsUsecase(categoryId: event.categoryId, page: 1),
      onLoading: () => emit(
        state.copyWith(
          getCategoryState: GetCategoryStates.loading,
          page: 1,
        ),
      ),
      onSuccess: (data) => emit(
        state.copyWith(
          getCategoryState: GetCategoryStates.success,
          categoryProducts: data.products,
          hasMore: data.hasMore,
          page: 1,
        ),
      ),
      onError: (message) => emit(
        state.copyWith(
          getCategoryState: GetCategoryStates.failure,
          getCategoryErrorMessage: message,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreCategoryProducts(
    LoadMoreCategoryProductsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (!state.hasMore || state.getCategoryState == GetCategoryStates.loading) {
      return;
    }

    final int nextPage = state.page + 1;

    final result = await getProductsUsecase(
      categoryId: event.categoryId,
      page: nextPage,
    );

    result.fold(
      (failure) {}, // Silent error for pagination or handle as needed
      (success) => emit(
        state.copyWith(
          getCategoryState: GetCategoryStates.success,
          categoryProducts: [
            ...state.categoryProducts,
            ...success.products,
          ],
          hasMore: success.hasMore,
          page: nextPage,
        ),
      ),
    );
  }
}
