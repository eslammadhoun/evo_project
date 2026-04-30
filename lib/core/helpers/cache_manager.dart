import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyCacheManager extends CacheManager {
  static const key = "customCache";

  static final MyCacheManager _instance = MyCacheManager._();

  factory MyCacheManager() {
    return _instance;
  }

  MyCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 20,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );
}
