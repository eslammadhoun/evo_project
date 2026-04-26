import 'package:evo_project/features/home/Domain/entities/product.dart';

class PaginatedProducts {
  final List<Product> products;
  final bool hasMore;

  PaginatedProducts({required this.products, required this.hasMore});
}
