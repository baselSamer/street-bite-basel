import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './presentation/blocs/cart/cart_bloc.dart';
import './core/api/api_endpoints.dart';
import './core/api/api_services.dart';
import './core/api/dio_factory.dart';
import './core/preferences/app_preferences.dart';
import './data/datasources/auth/firebase_auth_datasource.dart';
import './data/datasources/firebase/firestore_service.dart';
import './data/datasources/firebase/profile_photo_datasource.dart';
import './data/repositories/auth/auth_repository_impl.dart';
import './domain/repositories/auth/auth_repository.dart';
import './domain/usecases/auth/login_usecase.dart';
import './domain/usecases/auth/logout_usecase.dart';
import './domain/usecases/auth/sign_up_usecase.dart';
import './presentation/blocs/auth/auth_cubit.dart';
import './data/datasources/home/meal_datasource_factory.dart';
import './data/datasources/home/meal_local_datasource.dart';
import './data/datasources/home/meal_remote_datasource.dart';
import './data/repositories/home/meal_repository_impl.dart';
import './domain/repositories/home/meal_repository.dart';
import './domain/usecases/home/get_meals_usecase.dart';
import './presentation/blocs/home/meals_cubit.dart';
import './presentation/blocs/splash/splash_cubit.dart';
import './presentation/blocs/profile/profile_cubit.dart';
import './presentation/blocs/theme/theme_cubit.dart';
import './data/repositories/cash_payment_processor.dart';
import './data/datasources/device/biometric_profile_service.dart';
import './data/repositories/order/firestore_order_repository.dart';
import './data/repositories/favorites/firestore_favorites_repository.dart';
import './data/repositories/profile/firebase_profile_repository.dart';
import './domain/repositories/order_repository.dart';
import './domain/repositories/favorites_repository.dart';
import './domain/repositories/profile_repository.dart';
import './domain/repositories/profile_unlock_service.dart';
import './domain/repositories/payment_processor.dart';
import './domain/usecases/order/place_order_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ── Core ──────────────────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<AppPreferences>(() => AppPreferences(getIt()));
  getIt.registerSingleton<FirestoreService>(FirestoreService.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<ImagePicker>(() => ImagePicker());
  getIt.registerLazySingleton<ProfileUnlockService>(
    () => BiometricProfileService(LocalAuthentication()),
  );
  getIt.registerLazySingleton<ProfilePhotoDataSource>(
    () => ProfilePhotoDataSource(getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => FirebaseProfileRepository(
      FirebaseAuth.instance,
      getIt(),
      getIt(),
      getIt(),
    ),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(auth: getIt(), profile: getIt()),
  );

  // ── Settings cubits ───────────────────────────────────────────────────────
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt()));

  // ── Auth ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerFactory<SignUpUseCase>(() => SignUpUseCase(getIt()));
  getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: getIt(),
      signUpUseCase: getIt(),
      logoutUseCase: getIt(),
    ),
  );

  // ── Cart ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<CartBloc>(() => CartBloc());
  getIt.registerLazySingleton<PaymentProcessor>(() => CashPaymentProcessor());
  getIt.registerLazySingleton<OrderRepository>(
    () => FirestoreOrderRepository(getIt()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FirestoreFavoritesRepository(getIt()),
  );
  getIt.registerFactory<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(getIt(), getIt()),
  );

  // ── Splash ────────────────────────────────────────────────────────────────
  getIt.registerFactory<SplashCubit>(() => SplashCubit(getIt()));

  // ── Meals ─────────────────────────────────────────────────────────────────
  // Dedicated ApiServices for TheMealDB (different base URL from StreetBite API).
  getIt.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSource(
      ApiServices(DioFactory.createDio(), baseUrl: ApiEndpoints.mealDbBaseUrl),
    ),
  );
  getIt.registerLazySingleton<MealLocalDataSource>(
    () => MealLocalDataSource(getIt()),
  );
  getIt.registerLazySingleton<MealDataSourceFactory>(
    () => MealDataSourceFactory(remote: getIt(), local: getIt()),
  );
  getIt.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(getIt<MealDataSourceFactory>()),
  );
  getIt.registerFactory<GetMealsUseCase>(() => GetMealsUseCase(getIt()));
  getIt.registerLazySingleton<MealsCubit>(() => MealsCubit(getIt()));
}
