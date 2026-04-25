class ProductModel {
  String? productId;
  String? sku;
  String? name;
  String? description;
  String? metaDescription;
  String? special;
  String? price;
  String? currency;
  String? metaKeyword;
  String? productType;
  String? hasOptions;
  bool? freeShipping;
  String? shippingCountry;
  String? isReturnable;
  bool? isNew;
  bool? isExclusive;
  bool? isBestseller;
  List<Options>? options;
  List<Attributes>? attributes;
  int? quantity;
  List<Images>? images;
  String? manufacturerId;
  bool? manufacturer;
  String? discountPercentage;
  String? brandName;
  String? brandImage;
  String? sizeGuide;
  String? image;
  String? shareText;
  String? shareUrl;
  String? taxClassId;
  String? weight;
  String? length;
  String? width;
  String? height;
  int? rating;
  int? reviews;
  String? status;
  String? dateAdded;
  String? dateModified;
  String? categoryName;
  String? masterCategoryId;
  String? flashsaleSpecial;
  String? tamaraLink;
  String? tamaraText;
  String? tamaraSubText;
  bool? isShowTabbyLabel;
  String? preOrderText;
  bool? preOrderItem;
  String? preOrderNote;
  bool? isOutOfStock;
  String? outOfStockText;
  String? insiderCategoryId;
  String? insiderCategoryLabel;
  String? baseCurrency;
  String? baseCurrencyPrice;
  String? baseCurrencySpecialPrice;

  ProductModel({
    this.productId,
    this.sku,
    this.name,
    this.description,
    this.metaDescription,
    this.special,
    this.price,
    this.currency,
    this.metaKeyword,
    this.productType,
    this.hasOptions,
    this.freeShipping,
    this.shippingCountry,
    this.isReturnable,
    this.isNew,
    this.isExclusive,
    this.isBestseller,
    this.options,
    this.attributes,
    this.quantity,
    this.images,
    this.manufacturerId,
    this.manufacturer,
    this.discountPercentage,
    this.brandName,
    this.brandImage,
    this.sizeGuide,
    this.image,
    this.shareText,
    this.shareUrl,
    this.taxClassId,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.rating,
    this.reviews,
    this.status,
    this.dateAdded,
    this.dateModified,
    this.categoryName,
    this.masterCategoryId,
    this.flashsaleSpecial,
    this.tamaraLink,
    this.tamaraText,
    this.tamaraSubText,
    this.isShowTabbyLabel,
    this.preOrderText,
    this.preOrderItem,
    this.preOrderNote,
    this.isOutOfStock,
    this.outOfStockText,
    this.insiderCategoryId,
    this.insiderCategoryLabel,
    this.baseCurrency,
    this.baseCurrencyPrice,
    this.baseCurrencySpecialPrice,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    sku = json['sku'];
    name = json['name'];
    description = json['description'];
    metaDescription = json['meta_description'];
    special = json['special'];
    price = json['price'];
    currency = json['currency'];
    metaKeyword = json['meta_keyword'];
    productType = json['product_type'];
    hasOptions = json['has_options'];
    freeShipping = json['free_shipping'];
    shippingCountry = json['shipping_country'];
    isReturnable = json['is_returnable'];
    isNew = json['is_new'] ?? false;
    isExclusive = json['is_exclusive'] ?? false;
    isBestseller = json['is_bestseller'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
    quantity = (json['quantity'] is String)
        ? int.tryParse(json['quantity'])
        : json['quantity'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    manufacturerId = json['manufacturer_id'];
    manufacturer = json['manufacturer'];
    discountPercentage = json['discount_percentage'];
    brandName = json['brand_name'];
    brandImage = json['brand_image'];
    sizeGuide = json['size_guide'];
    image = json['image'];
    shareText = json['share_text'];
    shareUrl = json['share_url'];
    taxClassId = json['tax_class_id'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    rating = (json['rating'] is String)
        ? int.tryParse(json['rating'])
        : json['rating'];
    reviews = json['reviews'];
    status = json['status'];
    dateAdded = json['date_added'];
    dateModified = json['date_modified'];
    categoryName = json['category_name'];
    masterCategoryId = json['master_category_id'];
    flashsaleSpecial = json['flashsale_special'];
    tamaraLink = json['tamara_link'];
    tamaraText = json['tamara_text'];
    tamaraSubText = json['tamara_sub_text'];
    isShowTabbyLabel = json['isShowTabbyLabel'];
    preOrderText = json['pre_order_text'];
    preOrderItem = json['pre_order_item'];
    preOrderNote = json['pre_order_note'];
    isOutOfStock = json['is_out_of_stock'];
    outOfStockText = json['out_of_stock_text'];
    insiderCategoryId = json['insider_category_id'];
    insiderCategoryLabel = json['insider_category_label'];
    baseCurrency = json['base_currency'];
    baseCurrencyPrice = json['base_currency_price'];
    baseCurrencySpecialPrice = json['base_currency_special_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['sku'] = sku;
    data['name'] = name;
    data['description'] = description;
    data['meta_description'] = metaDescription;
    data['special'] = special;
    data['price'] = price;
    data['currency'] = currency;
    data['meta_keyword'] = metaKeyword;
    data['product_type'] = productType;
    data['has_options'] = hasOptions;
    data['free_shipping'] = freeShipping;
    data['shipping_country'] = shippingCountry;
    data['is_returnable'] = isReturnable;
    data['is_new'] = isNew;
    data['is_exclusive'] = isExclusive;
    data['is_bestseller'] = isBestseller;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = quantity;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['manufacturer_id'] = manufacturerId;
    data['manufacturer'] = manufacturer;
    data['discount_percentage'] = discountPercentage;
    data['brand_name'] = brandName;
    data['brand_image'] = brandImage;
    data['size_guide'] = sizeGuide;
    data['image'] = image;
    data['share_text'] = shareText;
    data['share_url'] = shareUrl;
    data['tax_class_id'] = taxClassId;
    data['weight'] = weight;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['rating'] = rating;
    data['reviews'] = reviews;
    data['status'] = status;
    data['date_added'] = dateAdded;
    data['date_modified'] = dateModified;
    data['category_name'] = categoryName;
    data['master_category_id'] = masterCategoryId;
    data['flashsale_special'] = flashsaleSpecial;
    data['tamara_link'] = tamaraLink;
    data['tamara_text'] = tamaraText;
    data['tamara_sub_text'] = tamaraSubText;
    data['isShowTabbyLabel'] = isShowTabbyLabel;
    data['pre_order_text'] = preOrderText;
    data['pre_order_item'] = preOrderItem;
    data['pre_order_note'] = preOrderNote;
    data['is_out_of_stock'] = isOutOfStock;
    data['out_of_stock_text'] = outOfStockText;
    data['insider_category_id'] = insiderCategoryId;
    data['insider_category_label'] = insiderCategoryLabel;
    data['base_currency'] = baseCurrency;
    data['base_currency_price'] = baseCurrencyPrice;
    data['base_currency_special_price'] = baseCurrencySpecialPrice;
    return data;
  }
}

class Options {
  String? name;
  String? productOptionId;
  String? required;
  String? sizeGuide;
  List<Variants>? variants;

  Options({
    this.name,
    this.productOptionId,
    this.required,
    this.sizeGuide,
    this.variants,
  });

  Options.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    productOptionId = json['product_option_id'];
    required = json['required'];
    sizeGuide = json['size_guide'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['product_option_id'] = productOptionId;
    data['required'] = required;
    data['size_guide'] = sizeGuide;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variants {
  String? label;
  String? priceVariance;
  String? optionId;
  String? description;
  String? availableQuantity;

  Variants({
    this.label,
    this.priceVariance,
    this.optionId,
    this.description,
    this.availableQuantity,
  });

  Variants.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    priceVariance = json['price_variance'];
    optionId = json['option_id'];
    description = json['description'];
    availableQuantity = json['available_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['price_variance'] = priceVariance;
    data['option_id'] = optionId;
    data['description'] = description;
    data['available_quantity'] = availableQuantity;
    return data;
  }
}

class Attributes {
  String? attributeGroupId;
  String? name;
  List<Attribute>? attribute;

  Attributes({this.attributeGroupId, this.name, this.attribute});

  Attributes.fromJson(Map<String, dynamic> json) {
    attributeGroupId = json['attribute_group_id'];
    name = json['name'];
    if (json['attribute'] != null) {
      attribute = <Attribute>[];
      json['attribute'].forEach((v) {
        attribute!.add(Attribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_group_id'] = attributeGroupId;
    data['name'] = name;
    if (attribute != null) {
      data['attribute'] = attribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attribute {
  String? attributeId;
  String? name;
  String? text;

  Attribute({this.attributeId, this.name, this.text});

  Attribute.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    name = json['name'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_id'] = attributeId;
    data['name'] = name;
    data['text'] = text;
    return data;
  }
}

class Images {
  String? url;

  Images({this.url});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
