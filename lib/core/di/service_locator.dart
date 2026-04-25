import 'package:dio/dio.dart';
import 'package:evo_project/core/network/api_client.dart';
import 'package:evo_project/core/network/app_interceptors.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/core/services/user_seesion.dart';
import 'package:evo_project/features/auth/Data/data_sources/auth_remote_datasource.dart';
import 'package:evo_project/features/auth/Data/repositories_imp/auth_repo_imp.dart';
import 'package:evo_project/features/auth/Domain/usecases/login.dart';
import 'package:evo_project/features/auth/Domain/usecases/logout.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/home/Data/datasources/products_datasource.dart';
import 'package:evo_project/features/home/Data/repositories/products_repository.dart';
import 'package:evo_project/features/home/Domain/usecases/get_product.dart';
import 'package:evo_project/features/home/Domain/usecases/get_category.dart';
import 'package:evo_project/features/home/Domain/usecases/get_related_products.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  //! Core Dependency
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  //* Helpers
  //* Services
  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

  //* Network
  sl.registerLazySingleton<ApiClient>(() => ApiClient(dioClient: sl()));
  sl.registerLazySingleton<AppInterceptors>(
    () => AppInterceptors(appPreferences: sl()),
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

  // ================================= Home =================================
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

  //* Blocs
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getProductsUsecase: sl<GetCategoryUsecase>(),
      getProductUsecase: sl<GetProductUsecase>(),
      getRelatedProductsUsecase: sl<GetRelatedProducts>(),
    ),
  );
}
