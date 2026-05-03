import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/presentation/bloc/states/category_products_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/dashboard_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/product_details_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/upload_profile_image_state.dart';

class HomeState extends Equatable {
  final CategoryProductsState categoryProductsState;
  final ProductDetailsState productDetailsState;
  final RelatedProductsState relatedProductsState;
  final DashboardState dashboardState;
  final ProfileImageState profileImageState;

  const HomeState({
    required this.categoryProductsState,
    required this.productDetailsState,
    required this.relatedProductsState,
    required this.dashboardState,
    required this.profileImageState,
  });

  factory HomeState.inital() {
    return HomeState(
      categoryProductsState: CategoryProductsState.inital(),
      productDetailsState: ProductDetailsState.inital(),
      relatedProductsState: RelatedProductsState.initial(),
      dashboardState: DashboardState.initial(),
      profileImageState: ProfileImageState.initial(),
    );
  }

  HomeState copyWith({
    CategoryProductsState? categoryProductsState,
    ProductDetailsState? productDetailsState,
    RelatedProductsState? relatedProductsState,
    DashboardState? dashboardState,
    ProfileImageState? profileImageState,
  }) {
    return HomeState(
      categoryProductsState:
          categoryProductsState ?? this.categoryProductsState,
      productDetailsState: productDetailsState ?? this.productDetailsState,
      relatedProductsState: relatedProductsState ?? this.relatedProductsState,
      dashboardState: dashboardState ?? this.dashboardState,
      profileImageState: profileImageState ?? this.profileImageState,
    );
  }

  @override
  List<Object?> get props => [
    categoryProductsState,
    productDetailsState,
    relatedProductsState,
    dashboardState,
    profileImageState,
  ];
}
