// import 'package:evo_project/features/home/Data/models/product_model.dart';

// class CategoryModel {
//   List<ProductModel>? products;
//   int? total;
//   int? productsTotal;
//   int? numberOfPages;
//   bool? hasMore;
//   Current? current;

//   CategoryModel({
//     this.products,
//     this.total,
//     this.productsTotal,
//     this.numberOfPages,
//     this.hasMore,
//     this.current,
//   });

//   CategoryModel.fromJson(Map<String, dynamic> json) {
//     if (json['products'] != null) {
//       products = <ProductModel>[];
//       json['products'].forEach((v) {
//         products!.add(ProductModel.fromJson(v));
//       });
//     }
//     total = json['total'];
//     productsTotal = json['products_total'];
//     numberOfPages = json['number_of_pages'];
//     hasMore = json['has_more'];
//     current = json['current'] != null
//         ? Current.fromJson(json['current'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (products != null) {
//       data['products'] = products!.map((v) => v.toJson()).toList();
//     }
//     data['total'] = total;
//     data['products_total'] = productsTotal;
//     data['number_of_pages'] = numberOfPages;
//     data['has_more'] = hasMore;
//     if (current != null) {
//       data['current'] = current!.toJson();
//     }
//     return data;
//   }
// }

// class Images {
//   String? url;

//   Images({this.url});

//   Images.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['url'] = url;
//     return data;
//   }
// }

// class Label {
//   String? text;
//   String? backgroundColor;
//   String? textColor;

//   Label({this.text, this.backgroundColor, this.textColor});

//   Label.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//     backgroundColor = json['background_color'];
//     textColor = json['text_color'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['text'] = text;
//     data['background_color'] = backgroundColor;
//     data['text_color'] = textColor;
//     return data;
//   }
// }

// class Current {
//   String? sort;

//   Current({this.sort});

//   Current.fromJson(Map<String, dynamic> json) {
//     sort = json['sort'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['sort'] = sort;
//     return data;
//   }
// }
