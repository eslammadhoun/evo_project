import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

enum GetTopBannerProductsState { initial, loading, success, failure }

class BannersState extends Equatable {
  final GetTopBannerProductsState getTopBannerProductsState;
  final String? getTopBannerProductsErrorMessage;
  final List<Product>? topBannerProducts;

  const BannersState({
    required this.getTopBannerProductsState,
    this.getTopBannerProductsErrorMessage,
    this.topBannerProducts,
  });

  factory BannersState.initial() {
    return BannersState(
      getTopBannerProductsState: GetTopBannerProductsState.initial,
    );
  }

  BannersState copyWith({
    GetTopBannerProductsState? getTopBannerProductsState,
    String? getTopBannerProductsErrorMessage,
    List<Product>? topBannerProducts,
  }) {
    return BannersState(
      getTopBannerProductsState:
          getTopBannerProductsState ?? this.getTopBannerProductsState,
      getTopBannerProductsErrorMessage:
          getTopBannerProductsErrorMessage ??
          this.getTopBannerProductsErrorMessage,
      topBannerProducts: topBannerProducts ?? this.topBannerProducts,
    );
  }

  @override
  List<Object?> get props => [
    getTopBannerProductsState,
    getTopBannerProductsErrorMessage,
    topBannerProducts,
  ];
}
