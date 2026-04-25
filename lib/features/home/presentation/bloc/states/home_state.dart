import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/presentation/bloc/states/banners_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/category_products_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/product_details_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';

class HomeState extends Equatable {
  final CategoryProductsState categoryProductsState;
  final ProductDetailsState productDetailsState;
  final RelatedProductsState relatedProductsState;
  final BannersState bannersState;

  const HomeState({
    required this.categoryProductsState,
    required this.productDetailsState,
    required this.relatedProductsState,
    required this.bannersState,
  });

  factory HomeState.inital() {
    return HomeState(
      categoryProductsState: CategoryProductsState.inital(),
      productDetailsState: ProductDetailsState.inital(),
      relatedProductsState: RelatedProductsState.initial(),
      bannersState: BannersState.initial(),
    );
  }

  HomeState copyWith({
    CategoryProductsState? categoryProductsState,
    ProductDetailsState? productDetailsState,
    RelatedProductsState? relatedProductsState,
    BannersState? bannersState,
  }) {
    return HomeState(
      categoryProductsState:
          categoryProductsState ?? this.categoryProductsState,
      productDetailsState: productDetailsState ?? this.productDetailsState,
      relatedProductsState: relatedProductsState ?? this.relatedProductsState,
      bannersState: bannersState ?? this.bannersState,
    );
  }

  @override
  List<Object?> get props => [
    categoryProductsState,
    productDetailsState,
    relatedProductsState,
    bannersState,
  ];
}
