class CartItemModel {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String size;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.size,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      image: json['image'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
      'size': size,
    };
  }
}
