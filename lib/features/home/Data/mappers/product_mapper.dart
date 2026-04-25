import 'package:evo_project/features/home/Data/models/product_model.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

extension ProductMapper on ProductModel {
  Product toEntity() {
    return Product(
      productId: productId,
      sku: sku,
      name: name,
      description: description,
      metaDescription: metaDescription,
      special: double.tryParse(special ?? ''),
      price: double.tryParse(price ?? ''),
      currency: currency,
      metaKeyword: metaKeyword,
      productType: productType,
      hasOptions: hasOptions,
      freeShipping: freeShipping,
      shippingCountry: shippingCountry,
      isReturnable: isReturnable,
      isNew: isNew,
      isExclusive: isExclusive,
      isBestseller: isBestseller,
      options: options?.map((e) => e.toEntity()).toList(),
      attributes: attributes?.map((e) => e.toEntity()).toList(),
      quantity: quantity ?? 0,
      images: images?.map((e) => e.toEntity()).toList(),
      manufacturerId: manufacturerId,
      manufacturer: manufacturer,
      discountPercentage: double.tryParse(discountPercentage ?? '') ?? 0.0,
      brandName: brandName,
      brandImage: brandImage,
      sizeGuide: sizeGuide,
      image: image,
      shareText: shareText,
      shareUrl: shareUrl,
      taxClassId: taxClassId,
      weight: double.tryParse(weight ?? ''),
      length: double.tryParse(length ?? ''),
      width: double.tryParse(width ?? ''),
      height: double.tryParse(height ?? ''),
      rating: rating,
      reviews: reviews,
      status: status,
      dateAdded: dateAdded,
      dateModified: dateModified,
      categoryName: categoryName,
      masterCategoryId: masterCategoryId,
      flashsaleSpecial: double.tryParse(flashsaleSpecial ?? ''),
      tamaraLink: tamaraLink,
      tamaraText: tamaraText,
      tamaraSubText: tamaraSubText,
      isShowTabbyLabel: isShowTabbyLabel,
      preOrderText: preOrderText,
      preOrderItem: preOrderItem,
      preOrderNote: preOrderNote,
      isOutOfStock: isOutOfStock,
      outOfStockText: outOfStockText,
      insiderCategoryId: insiderCategoryId,
      insiderCategoryLabel: insiderCategoryLabel,
      baseCurrency: baseCurrency,
      baseCurrencyPrice: double.tryParse(baseCurrencyPrice ?? ''),
      baseCurrencySpecialPrice: double.tryParse(baseCurrencySpecialPrice ?? ''),
    );
  }
}

extension ProductOptionMapper on Options {
  ProductOption toEntity() {
    return ProductOption(
      name: name,
      productOptionId: productOptionId,
      required: required == "1",
      sizeGuide: sizeGuide,
      variants: variants?.map((e) => e.toEntity()).toList(),
    );
  }
}

extension ProductVariantMapper on Variants {
  ProductVariant toEntity() {
    return ProductVariant(
      label: label,
      priceVariance: double.tryParse(priceVariance ?? ''),
      optionId: optionId,
      description: description,
      availableQuantity: availableQuantity,
    );
  }
}

extension ProductAttributesMapper on Attributes {
  ProductAttributes toEntity() {
    return ProductAttributes(
      attributeGroupId: attributeGroupId,
      name: name,
      attribute: attribute?.map((e) => e.toEntity()).toList(),
    );
  }
}

extension ProductAttributeMapper on Attribute {
  ProductAttribute toEntity() {
    return ProductAttribute(attributeId: attributeId, name: name, text: text);
  }
}

extension ProductImageMapper on Images {
  ProductImage toEntity() {
    return ProductImage(url: url);
  }
}
