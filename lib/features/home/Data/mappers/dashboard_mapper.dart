import 'package:evo_project/features/home/Data/models/dashboard_model.dart';
import 'package:evo_project/features/home/Domain/entities/dashboard_entity.dart';

extension DashboardMapper on DashboardModel {
  DashboardEntity toEntity() {
    return DashboardEntity(
      mId: mId,
      title: title,
      banners: banners.map(
        (key, value) => MapEntry(key, value.map((e) => e.toEntity()).toList()),
      ),
    );
  }
}

extension BannerMapper on BannerModel {
  BannerEntity toEntity() {
    return BannerEntity(
      title: title,
      mainCategory: mainCategory,
      type: type,
      description: description,
      categoryId: categoryId,
      url: url,
      sortOrder: sortOrder,
      images: images.map((e) => e.toEntity()).toList(),
      comment: comment,
      listType: listType,
    );
  }
}

extension ImageMapper on ImageModel {
  ImageEntity toEntity() {
    return ImageEntity(
      id: id,
      image: image,
      title: title,
      categoryId: categoryId,
      groupId: groupId,
      url: url,
      postion: postion,
      listType: listType,
    );
  }
}
