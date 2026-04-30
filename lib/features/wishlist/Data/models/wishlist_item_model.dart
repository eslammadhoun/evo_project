class WishlistItemModel {
  final String productId;
  final String name;
  final String image;
  final double price;
  final double rate;

  const WishlistItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.rate,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'rate': rate,
    };
  }
}
