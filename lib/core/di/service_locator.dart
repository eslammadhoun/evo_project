import 'package:dio/dio.dart';
import 'package:evo_project/core/Database/app_database.dart';
import 'package:evo_project/core/Database/database_provider.dart';
import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/app_interceptors.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/core/services/user_seesion.dart';
import 'package:evo_project/features/auth/Data/data_sources/auth_remote_datasource.dart';
import 'package:evo_project/features/auth/Data/repositories_imp/auth_repo_imp.dart';
import 'package:evo_project/features/auth/Domain/usecases/login.dart';
import 'package:evo_project/features/auth/Domain/usecases/logout.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/cart/Data/datasources/cart_local_datasource.dart';
import 'package:evo_project/features/cart/Data/repos/cart_repo.dart';
import 'package:evo_project/features/cart/Domain/usecases/add_product_to_cart.dart';
import 'package:evo_project/features/cart/Domain/usecases/delete_product_from_cart.dart';
import 'package:evo_project/features/cart/Domain/usecases/get_cart.dart';
import 'package:evo_project/features/cart/Domain/usecases/get_cart_discount.dart';
import 'package:evo_project/features/cart/Domain/usecases/set_cart_discount.dart';
import 'package:evo_project/features/cart/Domain/usecases/update_product_quantity.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/home/Data/datasources/products_datasource.dart';
import 'package:evo_project/features/home/Data/repositories/products_repository.dart';
import 'package:evo_project/features/home/Domain/usecases/get_dashboard.dart';
import 'package:evo_project/features/home/Domain/usecases/get_product.dart';
import 'package:evo_project/features/home/Domain/usecases/get_category.dart';
import 'package:evo_project/features/home/Domain/usecases/get_related_products.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:evo_project/features/notifications/Data/datasources/notifications_datasource.dart';
import 'package:evo_project/features/notifications/Data/repos/notifications_repo.dart';
import 'package:evo_project/features/notifications/Domain/usecases/get_notifications.dart';
import 'package:evo_project/features/notifications/Domain/usecases/insert_notification.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:evo_project/features/wishlist/Data/datasources/wishlist_datesource.dart';
import 'package:evo_project/features/wishlist/Data/repos/wishlist_repo.dart';
import 'package:evo_project/features/wishlist/Domain/Usecases/get_wishlist.dart';
import 'package:evo_project/features/wishlist/Domain/Usecases/toggle_wishlist.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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

  //* Helpers
  //* Services
  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));
  sl.registerLazySingleton<DatabaseProvider>(() => DatabaseProvider());
  sl.registerLazySingleton<AppDatabase>(
    () => AppDatabase(sl<DatabaseProvider>()),
  );

  //* Network
  sl.registerLazySingleton<ApiClient>(() => ApiClient(dioClient: sl()));
  sl.registerLazySingleton<AppInterceptors>(
    () => AppInterceptors(appPreferences: sl(), dio: sl<Dio>()),
  );
  sl.registerLazySingleton<UserSeesion>(
    () => UserSeesion(
      apiConsumer: sl<ApiClient>(),
      appPreferences: sl<AppPreferences>(),
    ),
  );

  //! Features
  // ================================= Auth =================================
  //* Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(userSeesion: sl<UserSeesion>()),
  );

  //* repositories
  sl.registerLazySingleton<AuthRepoImp>(
    () => AuthRepoImp(
      authRemoteDatasource: sl<AuthRemoteDatasource>(),
      appPreferences: sl<AppPreferences>(),
    ),
  );

  //* UseCases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: sl<AuthRepoImp>()),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(authRepository: sl<AuthRepoImp>()),
  );

  //* Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      logoutUsecase: sl<LogoutUsecase>(),
    ),
  );

  // ================================= Start Home Feature =================================
  //* Data sources
  sl.registerLazySingleton<ProductsDatasource>(
    () => ProductsDatasource(apiClient: sl<ApiClient>()),
  );

  //* repositories
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepository(productsDatasource: sl<ProductsDatasource>()),
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

  //* Blocs
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getProductsUsecase: sl<GetCategoryUsecase>(),
      getProductUsecase: sl<GetProductUsecase>(),
      getRelatedProductsUsecase: sl<GetRelatedProducts>(),
      getDashboardUsecase: sl<GetDashboardUsecase>(),
    ),
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
    () => CartRepository(localDataSource: sl<CartLocalDataSource>()),
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
    () => SetCartDiscount(cartLocalDataSource: sl<CartLocalDataSource>()),
  );
  sl.registerLazySingleton<GetCartDiscountState>(
    () => GetCartDiscountState(cartLocalDataSource: sl<CartLocalDataSource>()),
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
  sl.registerLazySingleton<WishlistDatesource>(
    () => WishlistDatesource(appDatabase: sl<AppDatabase>()),
  );

  //* Repos
  sl.registerLazySingleton<WishlistRepo>(
    () => WishlistRepo(datasource: sl<WishlistDatesource>()),
  );

  //* Use cases
  sl.registerLazySingleton<GetWishlist>(() => GetWishlist(sl<WishlistRepo>()));
  sl.registerLazySingleton<ToggleWishlist>(
    () => ToggleWishlist(sl<WishlistRepo>()),
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
  sl.registerLazySingleton<NotificationsRepo>(
    () => NotificationsRepo(
      notificationsDatasource: sl<NotificationsDatasource>(),
    ),
  );

  //* Use cases
  sl.registerLazySingleton<GetNotifications>(
    () => GetNotifications(notificationsRepo: sl<NotificationsRepo>()),
  );
  sl.registerLazySingleton<InsertNotification>(
    () => InsertNotification(notificationsRepo: sl<NotificationsRepo>()),
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
