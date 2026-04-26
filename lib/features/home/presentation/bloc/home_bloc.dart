import 'package:evo_project/core/helpers/bloc_request_handler.dart';
import 'package:evo_project/features/home/Domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/Domain/entities/paginated_products.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';
import 'package:evo_project/features/home/Domain/usecases/get_dashboard.dart';
import 'package:evo_project/features/home/Domain/usecases/get_product.dart';
import 'package:evo_project/features/home/Domain/usecases/get_category.dart';
import 'package:evo_project/features/home/Domain/usecases/get_related_products.dart';
import 'package:evo_project/features/home/presentation/bloc/home_event.dart';
import 'package:evo_project/features/home/presentation/bloc/states/category_products_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/dashboard_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/home_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/product_details_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoryUsecase getProductsUsecase;
  final GetProductUsecase getProductUsecase;
  final GetRelatedProducts getRelatedProductsUsecase;
  final GetDashboardUsecase getDashboardUsecase;
  HomeBloc({
    required this.getProductsUsecase,
    required this.getProductUsecase,
    required this.getRelatedProductsUsecase,
    required this.getDashboardUsecase,
  }) : super(HomeState.inital()) {
    on<GetCatecoryProductsEvent>(_getCatecoryProducts);
    on<GetProductEvent>(_getProductDetails);
    on<GetRelatedProductsEvent>(_onGetRelatedProducts);
    on<GetDashboardEvent>(_onGetDashboard);
    on<LoadMoreCategoryProductsEvent>(_onLoadmoreCategoryProducts);
  }

  Future<void> _getCatecoryProducts(
    GetCatecoryProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    await blocRequestHandeler<PaginatedProducts>(
      request: () => getProductsUsecase(catecoryId: event.categoryId, page: 1),
      onLoading: () => emit(
        state.copyWith(
          categoryProductsState: CategoryProductsState(
            getCategoryState: GetCategoryStates.loading,
            page: 1,
          ),
        ),
      ),
      onSuccess: (data) => emit(
        state.copyWith(
          categoryProductsState: CategoryProductsState(
            getCategoryState: GetCategoryStates.success,
            categoryProducts: data.products,
            hasMore: data.hasMore,
            page: 1,
          ),
        ),
      ),
      onError: (message) => emit(
        state.copyWith(
          categoryProductsState: CategoryProductsState(
            getCategoryState: GetCategoryStates.failure,
            getCategoryErrorMessage: message,
          ),
        ),
      ),
    );
  }

  Future<void> _getProductDetails(
    GetProductEvent event,
    Emitter<HomeState> emit,
  ) async {
    await blocRequestHandeler<Product>(
      request: () => getProductUsecase(productId: event.productId),
      onLoading: () => emit(
        state.copyWith(
          productDetailsState: ProductDetailsState(
            getProductDetailsState: GetProductDetails.loading,
          ),
        ),
      ),
      onSuccess: (product) {
        emit(
          state.copyWith(
            productDetailsState: ProductDetailsState(
              getProductDetailsState: GetProductDetails.success,
              product: product,
            ),
          ),
        );
      },
      onError: (messsage) {
        emit(
          state.copyWith(
            productDetailsState: ProductDetailsState(
              getProductDetailsState: GetProductDetails.failure,
              getProductDetailsErrorMessage: messsage,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onGetRelatedProducts(
    GetRelatedProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    await blocRequestHandeler<List<Product>>(
      request: () => getRelatedProductsUsecase(productId: event.productId),
      onLoading: () => emit(
        state.copyWith(
          relatedProductsState: RelatedProductsState(
            getRelatedProductsState: GetRelatedProductsStates.loading,
          ),
        ),
      ),
      onSuccess: (listOfProducts) => emit(
        state.copyWith(
          relatedProductsState: RelatedProductsState(
            getRelatedProductsState: GetRelatedProductsStates.success,
            relatedProducts: listOfProducts,
          ),
        ),
      ),
      onError: (errorMessage) => emit(
        state.copyWith(
          relatedProductsState: RelatedProductsState(
            getRelatedProductsState: GetRelatedProductsStates.success,
            getRelatedProductsErrorMessage: errorMessage,
          ),
        ),
      ),
    );
  }

  Future<void> _onGetDashboard(
    GetDashboardEvent event,
    Emitter<HomeState> emit,
  ) async {
    await blocRequestHandeler<DashboardEntity>(
      request: () => getDashboardUsecase(),
      onLoading: () => emit(
        state.copyWith(
          dashboardState: DashboardState(
            getDashboardState: GetDashboardStates.loading,
          ),
        ),
      ),
      onSuccess: (dashboardEntity) => emit(
        state.copyWith(
          dashboardState: DashboardState(
            getDashboardState: GetDashboardStates.success,
            dashboardEntity: dashboardEntity,
            topBanners: dashboardEntity.banners['top_banner'] ?? [],
            footerBanners: dashboardEntity.banners['footer_banner'] ?? [],
          ),
        ),
      ),
      onError: (errorMessage) => emit(
        state.copyWith(
          dashboardState: DashboardState(
            getDashboardState: GetDashboardStates.failure,
            getDashboardErrorMessage: errorMessage,
          ),
        ),
      ),
    );
  }

  Future<void> _onLoadmoreCategoryProducts(
    LoadMoreCategoryProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final current = state.categoryProductsState;
    if (!current.hasMore) return;
    if (!current.hasMore ||
        current.getCategoryState == GetCategoryStates.loading) {
      return;
    }

    final int nextPage = current.page + 1;

    final getMoreProductsResult = await getProductsUsecase(
      catecoryId: event.categoryId,
      page: nextPage,
    );

    getMoreProductsResult.fold(
      (failure) {},
      (success) => emit(
        state.copyWith(
          categoryProductsState: current.copyWith(
            getCategoryState: GetCategoryStates.success,
            categoryProducts: [
              ...current.categoryProducts!,
              ...success.products,
            ],
            hasMore: success.hasMore,
            page: nextPage,
          ),
        ),
      ),
    );
  }
}
