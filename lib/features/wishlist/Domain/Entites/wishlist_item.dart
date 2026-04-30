import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final String productId;
  final String name;
  final String image;
  final double price;
  final double rate;

  const WishlistItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.rate,
  });

  @override
  List<Object?> get props => [productId, name, image, price, rate];
}
