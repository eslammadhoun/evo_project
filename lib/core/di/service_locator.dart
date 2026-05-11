import 'package:dio/dio.dart';
import 'package:evo_project/core/Database/app_database.dart';
import 'package:evo_project/core/Database/database_provider.dart';
import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/app_interceptors.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/core/services/user_session.dart';
import 'package:evo_project/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:evo_project/features/auth/data/repositories_imp/auth_repo_imp.dart';
import 'package:evo_project/features/auth/domain/usecases/login.dart';
import 'package:evo_project/features/auth/domain/usecases/logout.dart';
import 'package:evo_project/features/auth/domain/usecases/register.dart';
import 'package:evo_project/features/auth/domain/repositories/auth_reposotory.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:evo_project/features/cart/data/repos/cart_repo_imp.dart';
import 'package:evo_project/features/cart/domain/repositories/cart_repository.dart';
import 'package:evo_project/features/cart/domain/usecases/add_product_to_cart.dart';
import 'package:evo_project/features/cart/domain/usecases/delete_product_from_cart.dart';
import 'package:evo_project/features/cart/domain/usecases/get_cart.dart';
import 'package:evo_project/features/cart/domain/usecases/get_cart_discount.dart';
import 'package:evo_project/features/cart/domain/usecases/set_cart_discount.dart';
import 'package:evo_project/features/cart/domain/usecases/update_product_quantity.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/home/data/datasources/products_datasource.dart';
import 'package:evo_project/features/home/data/datasources/profile_image_datasource.dart';
import 'package:evo_project/features/home/data/repositories/products_repository_imp.dart';
import 'package:evo_project/features/home/domain/repositories/products_repository.dart';
import 'package:evo_project/features/home/domain/usecases/get_dashboard.dart';
import 'package:evo_project/features/home/domain/usecases/get_product.dart';
import 'package:evo_project/features/home/domain/usecases/get_category.dart';
import 'package:evo_project/features/home/domain/usecases/get_related_products.dart';
import 'package:evo_project/features/home/domain/usecases/upload_profile_image.dart';
import 'package:evo_project/features/home/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/product_details/product_details_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/profile/profile_bloc.dart';
import 'package:evo_project/features/notifications/data/datasources/notifications_datasource.dart';
import 'package:evo_project/features/notifications/data/repos/notifications_repo_imp.dart';
import 'package:evo_project/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:evo_project/features/notifications/domain/usecases/get_notifications.dart';
import 'package:evo_project/features/notifications/domain/usecases/insert_notification.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:evo_project/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:evo_project/features/wishlist/data/repos/wishlist_repo_imp.dart';
import 'package:evo_project/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:evo_project/features/wishlist/domain/usecases/get_wishlist.dart';
import 'package:evo_project/features/wishlist/domain/usecases/toggle_wishlist.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton<GlobalKey<NavigatorState>>(
    () => GlobalKey<NavigatorState>(),
  );
  //! Core Dependency
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(
    () => const FlutterSecureStorage(
      // Use EncryptedSharedPreferences on Android (AES-256, API 23+)
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  //* Helpers
  //* Services
  sl.registerLazySingleton<AppPreferences>(
    () => AppPreferences(sl(), sl<FlutterSecureStorage>()),
  );
  // Load (and migrate) the token into memory before any network call fires.
  await sl<AppPreferences>().loadToken();
  sl.registerLazySingleton<DatabaseProvider>(() => DatabaseProvider());
  sl.registerLazySingleton<AppDatabase>(
    () => AppDatabase(sl<DatabaseProvider>()),
  );

  //* Network
  sl.registerLazySingleton<AppInterceptors>(
    () => AppInterceptors(appPreferences: sl(), dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ApiConsumer>(
    () => ApiClient(dioClient: sl(), interceptors: sl<AppInterceptors>()),
  );
  sl.registerLazySingleton<UserSession>(
    () => UserSession(appPreferences: sl<AppPreferences>()),
  );

  //! Features
  // ================================= Auth =================================
  //* Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(apiConsumer: sl<ApiConsumer>()),
  );

  //* repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepoImp(
      authRemoteDatasource: sl<AuthRemoteDatasource>(),
      appPreferences: sl<AppPreferences>(),
    ),
  );

  //* UseCases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(
      authRepository: sl<AuthRepository>(),
      appDatabase: sl<AppDatabase>(),
    ),
  );

  //* Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      logoutUsecase: sl<LogoutUsecase>(),
      registerUseCase: sl<RegisterUseCase>(),
    ),
  );

  // ================================= Start Home Feature =================================
  //* Data sources
  sl.registerLazySingleton<ProductsDatasource>(
    () => ProductsDatasource(apiClient: sl<ApiConsumer>()),
  );
  sl.registerLazySingleton(() => ProfileImageDatasource(dioClient: sl<Dio>()));

  //* repositories
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImp(productsDatasource: sl<ProductsDatasource>()),
  );

  //* UseCases
  sl.registerLazySingleton<GetCategoryUsecase>(
    () => GetCategoryUsecase(productsRepository: sl<ProductsRepository>()),
  );
  sl.registerLazySingleton<GetProductUsecase>(
    () => GetProductUsecase(productsRepository: sl<ProductsRepository>()),
  );
  sl.registerLazySingleton<GetRelatedProducts>(
    () => GetRelatedProducts(productsRepository: sl<ProductsRepository>()),
  );
  sl.registerLazySingleton<GetDashboardUsecase>(
    () => GetDashboardUsecase(productsRepository: sl<ProductsRepository>()),
  );
  sl.registerLazySingleton<UploadProfileImageUsecase>(
    () => UploadProfileImageUsecase(
      profileImageDatasource: sl<ProfileImageDatasource>(),
    ),
  );
  //* Blocs
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(getDashboardUsecase: sl<GetDashboardUsecase>()),
  );
  sl.registerFactory<CategoryBloc>(
    () => CategoryBloc(getProductsUsecase: sl<GetCategoryUsecase>()),
  );
  sl.registerFactory<ProductDetailsBloc>(
    () => ProductDetailsBloc(
      getProductUsecase: sl<GetProductUsecase>(),
      getRelatedProductsUsecase: sl<GetRelatedProducts>(),
    ),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(uploadProfileImageUsecase: sl<UploadProfileImageUsecase>()),
  );

  // ================================= End Home Feature =============================

  // ================================= Start Cart Feature =================================
  //* Data sources
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSource(
      appDatabase: sl<AppDatabase>(),
      appPreferences: sl<AppPreferences>(),
    ),
  );

  //* Repos
  sl.registerLazySingleton<CartRepository>(
    () => CartRepoImp(localDataSource: sl<CartLocalDataSource>()),
  );

  //* Use cases
  sl.registerLazySingleton<GetCartUsecase>(
    () => GetCartUsecase(cartRepository: sl<CartRepository>()),
  );
  sl.registerLazySingleton<AddProductToCart>(
    () => AddProductToCart(cartRepository: sl<CartRepository>()),
  );
  sl.registerLazySingleton<DeleteProductFromCart>(
    () => DeleteProductFromCart(cartRepository: sl<CartRepository>()),
  );
  sl.registerLazySingleton<UpdateProductQuantity>(
    () => UpdateProductQuantity(cartRepository: sl<CartRepository>()),
  );
  sl.registerLazySingleton<SetCartDiscount>(
    () => SetCartDiscount(cartRepository: sl<CartRepository>()),
  );
  sl.registerLazySingleton<GetCartDiscountState>(
    () => GetCartDiscountState(cartRepository: sl<CartRepository>()),
  );

  // * Blocs
  sl.registerFactory<CartBloc>(
    () => CartBloc(
      getCartUsecase: sl<GetCartUsecase>(),
      addProductToCartUsecase: sl<AddProductToCart>(),
      deleteProductFromCartUsecase: sl<DeleteProductFromCart>(),
      updateProductQuantityUsecase: sl<UpdateProductQuantity>(),
      setCartDiscountUsecase: sl<SetCartDiscount>(),
      getCartDiscountStateUsecase: sl<GetCartDiscountState>(),
    ),
  );

  // ================================= End Cart Feature =================================

  // ================================= Start Wishlist Feature =================================
  //* Data sources
  sl.registerLazySingleton<WishlistDatasource>(
    () => WishlistDatasource(appDatabase: sl<AppDatabase>()),
  );

  //* Repos
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepoImp(datasource: sl<WishlistDatasource>()),
  );

  //* Use cases
  sl.registerLazySingleton<GetWishlist>(() => GetWishlist(sl<WishlistRepository>()));
  sl.registerLazySingleton<ToggleWishlist>(
    () => ToggleWishlist(sl<WishlistRepository>()),
  );

  // * Blocs
  sl.registerFactory<WishlistBloc>(
    () => WishlistBloc(
      getWishlist: sl<GetWishlist>(),
      toggleWishlistUsecase: sl<ToggleWishlist>(),
    ),
  );
  // ================================= End Wishlist Feature =================================

  // ================================= Start Notifications Feature ==========================
  //* Data sources
  sl.registerLazySingleton<NotificationsDatasource>(
    () => NotificationsDatasource(database: sl<AppDatabase>()),
  );

  //* Repos
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepoImp(
      notificationsDatasource: sl<NotificationsDatasource>(),
    ),
  );

  //* Use cases
  sl.registerLazySingleton<GetNotifications>(
    () => GetNotifications(notificationsRepo: sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton<InsertNotification>(
    () => InsertNotification(notificationsRepo: sl<NotificationsRepository>()),
  );

  // * Blocs
  sl.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      getNotificationsUsecase: sl<GetNotifications>(),
      insertNotificationUsecase: sl<InsertNotification>(),
    ),
  );

  // ================================= End Notifications Feature ============================
}
