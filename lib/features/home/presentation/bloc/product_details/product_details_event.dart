import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetProductEvent extends ProductDetailsEvent {
  final String productId;
  const GetProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class GetRelatedProductsEvent extends ProductDetailsEvent {
  final String productId;
  const GetRelatedProductsEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
