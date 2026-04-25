import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/presentation/bloc/states/category_products_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/dashboard_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/product_details_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';

class HomeState extends Equatable {
  final CategoryProductsState categoryProductsState;
  final ProductDetailsState productDetailsState;
  final RelatedProductsState relatedProductsState;
  final DashboardState dashboardState;

  const HomeState({
    required this.categoryProductsState,
    required this.productDetailsState,
    required this.relatedProductsState,
    required this.dashboardState,
  });

  factory HomeState.inital() {
    return HomeState(
      categoryProductsState: CategoryProductsState.inital(),
      productDetailsState: ProductDetailsState.inital(),
      relatedProductsState: RelatedProductsState.initial(),
      dashboardState: DashboardState.initial(),
    );
  }

  HomeState copyWith({
    CategoryProductsState? categoryProductsState,
    ProductDetailsState? productDetailsState,
    RelatedProductsState? relatedProductsState,
    DashboardState? dashboardState,
  }) {
    return HomeState(
      categoryProductsState:
          categoryProductsState ?? this.categoryProductsState,
      productDetailsState: productDetailsState ?? this.productDetailsState,
      relatedProductsState: relatedProductsState ?? this.relatedProductsState,
      dashboardState: dashboardState ?? this.dashboardState,
    );
  }

  @override
  List<Object?> get props => [
    categoryProductsState,
    productDetailsState,
    relatedProductsState,
    dashboardState,
  ];
}
