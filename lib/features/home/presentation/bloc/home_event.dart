abstract class HomeEvent {
  const HomeEvent();
}

class GetCatecoryProductsEvent extends HomeEvent {
  final String categoryId;

  const GetCatecoryProductsEvent({required this.categoryId});
}

class GetProductEvent extends HomeEvent {
  final String productId;

  const GetProductEvent({required this.productId});
}

class GetRelatedProductsEvent extends HomeEvent {
  final String productId;
  const GetRelatedProductsEvent({required this.productId});
}

class GetTopBannersEvent extends HomeEvent {}
