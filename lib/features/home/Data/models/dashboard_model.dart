class DashboardModel {
  final int mId;
  final String title;
  final Map<String, List<BannerModel>> banners;

  DashboardModel({
    required this.mId,
    required this.title,
    required this.banners,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final bannerMap = <String, List<BannerModel>>{};

    if (json['banners'] != null) {
      json['banners'].forEach((key, value) {
        bannerMap[key] = (value as List)
            .map((e) => BannerModel.fromJson(e))
            .toList();
      });
    }

    return DashboardModel(
      mId: json['m_id'] ?? 0,
      title: json['title'] ?? '',
      banners: bannerMap,
    );
  }
}

class BannerModel {
  final String title;
  final String mainCategory;
  final String type;
  final String description;
  final String categoryId;
  final String url;
  final String sortOrder;
  final List<ImageModel> images;
  final String comment;
  final int listType;

  BannerModel({
    required this.title,
    required this.mainCategory,
    required this.type,
    required this.description,
    required this.categoryId,
    required this.url,
    required this.sortOrder,
    required this.images,
    required this.comment,
    required this.listType,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['title'] ?? '',
      mainCategory: json['main_category'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category_id'] ?? '',
      url: json['url'] ?? '',
      sortOrder: json['sort_order'] ?? '',
      images: (json['images'] as List? ?? [])
          .map((e) => ImageModel.fromJson(e))
          .toList(),
      comment: json['comment'] ?? '',
      listType: json['list_type'] ?? 0,
    );
  }
}

class ImageModel {
  final String id;
  final String image;
  final String title;
  final String categoryId;
  final String groupId;
  final String url;
  final String postion;
  final String listType;

  ImageModel({
    required this.id,
    required this.image,
    required this.title,
    required this.categoryId,
    required this.groupId,
    required this.url,
    required this.postion,
    required this.listType,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id']?.toString() ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      categoryId: json['category_id'] ?? '',
      groupId: json['group_id'] ?? '',
      url: json['url']?.toString() ?? '',
      postion: json['postion']?.toString() ?? '',
      listType: json['list_type']?.toString() ?? '',
    );
  }
}
