class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String size;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.size,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? image,
    String? size,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      size: size ?? this.size,
    );
  }
}
