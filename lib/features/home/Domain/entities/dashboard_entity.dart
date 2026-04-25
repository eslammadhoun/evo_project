class DashboardEntity {
  final int mId;
  final String title;
  final Map<String, List<BannerEntity>> banners;

  DashboardEntity({
    required this.mId,
    required this.title,
    required this.banners,
  });
}

class BannerEntity {
  final String title;
  final String mainCategory;
  final String type;
  final String description;
  final String categoryId;
  final String url;
  final String sortOrder;
  final List<ImageEntity> images;
  final String comment;
  final int listType;

  BannerEntity({
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
}

class ImageEntity {
  final String id;
  final String image;
  final String title;
  final String categoryId;
  final String groupId;
  final String url;
  final String postion;
  final String listType;

  ImageEntity({
    required this.id,
    required this.image,
    required this.title,
    required this.categoryId,
    required this.groupId,
    required this.url,
    required this.postion,
    required this.listType,
  });
}
