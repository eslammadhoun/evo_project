class Product {
  final String? productId;
  final String? sku;
  final String? name;
  final String? description;
  final String? metaDescription;
  final double? special;
  final double? price;
  final String? currency;
  final String? metaKeyword;
  final String? productType;
  final String? hasOptions;
  final bool? freeShipping;
  final String? shippingCountry;
  final String? isReturnable;
  final bool? isNew;
  final bool? isExclusive;
  final bool? isBestseller;
  final List<ProductOption>? options;
  final List<ProductAttributes>? attributes;
  final int? quantity;
  final List<ProductImage>? images;
  final String? manufacturerId;
  final bool? manufacturer;
  final double? discountPercentage;
  final String? brandName;
  final String? brandImage;
  final String? sizeGuide;
  final String? image;
  final String? shareText;
  final String? shareUrl;
  final String? taxClassId;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final int? rating;
  final int? reviews;
  final String? status;
  final String? dateAdded;
  final String? dateModified;
  final String? categoryName;
  final String? masterCategoryId;
  final double? flashsaleSpecial;
  final String? tamaraLink;
  final String? tamaraText;
  final String? tamaraSubText;
  final bool? isShowTabbyLabel;
  final String? preOrderText;
  final bool? preOrderItem;
  final String? preOrderNote;
  final bool? isOutOfStock;
  final String? outOfStockText;
  final String? insiderCategoryId;
  final String? insiderCategoryLabel;
  final String? baseCurrency;
  final double? baseCurrencyPrice;
  final double? baseCurrencySpecialPrice;

  Product({
    required this.productId,
    required this.sku,
    required this.name,
    required this.description,
    required this.metaDescription,
    required this.special,
    required this.price,
    required this.currency,
    required this.metaKeyword,
    required this.productType,
    required this.hasOptions,
    required this.freeShipping,
    required this.shippingCountry,
    required this.isReturnable,
    required this.isNew,
    required this.isExclusive,
    required this.isBestseller,
    required this.options,
    required this.attributes,
    required this.quantity,
    required this.images,
    required this.manufacturerId,
    required this.manufacturer,
    required this.discountPercentage,
    required this.brandName,
    required this.brandImage,
    required this.sizeGuide,
    required this.image,
    required this.shareText,
    required this.shareUrl,
    required this.taxClassId,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.rating,
    required this.reviews,
    required this.status,
    required this.dateAdded,
    required this.dateModified,
    required this.categoryName,
    required this.masterCategoryId,
    required this.flashsaleSpecial,
    required this.tamaraLink,
    required this.tamaraText,
    required this.tamaraSubText,
    required this.isShowTabbyLabel,
    required this.preOrderText,
    required this.preOrderItem,
    required this.preOrderNote,
    required this.isOutOfStock,
    required this.outOfStockText,
    required this.insiderCategoryId,
    required this.insiderCategoryLabel,
    required this.baseCurrency,
    required this.baseCurrencyPrice,
    required this.baseCurrencySpecialPrice,
  });
}

class ProductOption {
  final String? name;
  final String? productOptionId;
  final bool? required;
  final String? sizeGuide;
  final List<ProductVariant>? variants;

  ProductOption({
    this.name,
    this.productOptionId,
    this.required,
    this.sizeGuide,
    this.variants,
  });
}

class ProductVariant {
  final String? label;
  final double? priceVariance;
  final String? optionId;
  final String? description;
  final String? availableQuantity;

  ProductVariant({
    this.label,
    this.priceVariance,
    this.optionId,
    this.description,
    this.availableQuantity,
  });
}

class ProductAttributes {
  final String? attributeGroupId;
  final String? name;
  final List<ProductAttribute>? attribute;

  ProductAttributes({this.attributeGroupId, this.name, this.attribute});
}

class ProductAttribute {
  final String? attributeId;
  final String? name;
  final String? text;

  ProductAttribute({this.attributeId, this.name, this.text});
}

class ProductImage {
  final String? url;

  ProductImage({this.url});
}
