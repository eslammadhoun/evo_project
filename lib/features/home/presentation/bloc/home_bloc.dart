import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';
import 'package:evo_project/features/home/Domain/usecases/get_product.dart';
import 'package:evo_project/features/home/Domain/usecases/get_category.dart';
import 'package:evo_project/features/home/Domain/usecases/get_related_products.dart';
import 'package:evo_project/features/home/presentation/bloc/home_event.dart';
import 'package:evo_project/features/home/presentation/bloc/states/banners_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/category_products_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/home_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/product_details_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoryUsecase getProductsUsecase;
  final GetProductUsecase getProductUsecase;
  final GetRelatedProducts getRelatedProductsUsecase;
  HomeBloc({
    required this.getProductsUsecase,
    required this.getProductUsecase,
    required this.getRelatedProductsUsecase,
  }) : super(HomeState.inital()) {
    on<GetCatecoryProductsEvent>(_getCatecoryProducts);
    on<GetProductEvent>(_getProductDetails);
    on<GetRelatedProductsEvent>(_onGetRelatedProducts);
    on<GetTopBannersEvent>(_onGetTopBannersProducts);
  }

  Future<void> _getCatecoryProducts(
    GetCatecoryProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        categoryProductsState: CategoryProductsState(
          getCategoryState: GetCategoryStates.loading,
        ),
      ),
    );

    final Either<Failure, List<Product>> getProductsResult =
        await getProductsUsecase(catecoryId: event.categoryId);
    getProductsResult.fold(
      (failure) => emit(
        state.copyWith(
          categoryProductsState: CategoryProductsState(
            getCategoryState: GetCategoryStates.failure,
            getCategoryErrorMessage: failure.message,
          ),
        ),
      ),
      (success) => emit(
        state.copyWith(
          categoryProductsState: CategoryProductsState(
            getCategoryState: GetCategoryStates.success,
            categoryProducts: success,
          ),
        ),
      ),
    );
  }

  Future<void> _getProductDetails(
    GetProductEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        productDetailsState: ProductDetailsState(
          getProductDetailsState: GetProductDetails.loading,
        ),
      ),
    );

    final getProductResult = await getProductUsecase(
      productId: event.productId,
    );

    getProductResult.fold(
      (failure) => emit(
        state.copyWith(
          productDetailsState: ProductDetailsState(
            getProductDetailsState: GetProductDetails.failure,
            getProductDetailsErrorMessage: failure.message,
          ),
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            productDetailsState: ProductDetailsState(
              getProductDetailsState: GetProductDetails.success,
              product: success,
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
    emit(
      state.copyWith(
        relatedProductsState: RelatedProductsState(
          getRelatedProductsState: GetRelatedProductsStates.loading,
        ),
      ),
    );

    final getProductResult = await getRelatedProductsUsecase(
      productId: event.productId,
    );

    getProductResult.fold(
      (failure) => emit(
        state.copyWith(
          relatedProductsState: RelatedProductsState(
            getRelatedProductsState: GetRelatedProductsStates.failure,
            getRelatedProductsErrorMessage: failure.message,
          ),
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            relatedProductsState: RelatedProductsState(
              getRelatedProductsState: GetRelatedProductsStates.success,
              relatedProducts: success,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onGetTopBannersProducts(
    GetTopBannersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        bannersState: BannersState(
          getTopBannerProductsState: GetTopBannerProductsState.loading,
        ),
      ),
    );

    final Either<Failure, List<Product>> getProductsResult =
        await getProductsUsecase(catecoryId: '1');
    getProductsResult.fold(
      (failure) => emit(
        state.copyWith(
          bannersState: BannersState(
            getTopBannerProductsState: GetTopBannerProductsState.failure,
            getTopBannerProductsErrorMessage: failure.message,
          ),
        ),
      ),
      (success) => emit(
        state.copyWith(
          bannersState: BannersState(
            getTopBannerProductsState: GetTopBannerProductsState.success,
            topBannerProducts: success,
          ),
        ),
      ),
    );
  }
}
