import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryProductsEvent extends CategoryEvent {
  final String categoryId;
  const GetCategoryProductsEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class LoadMoreCategoryProductsEvent extends CategoryEvent {
  final String categoryId;
  const LoadMoreCategoryProductsEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
