// lib/core/dependency_injections.dart
import 'package:get_it/get_it.dart';
import '../data/repositories/astronomy_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/services/nasa_api_service.dart';
import '../data/services/auth_local_service.dart';
import '../data/services/auth_firebase_service.dart';
import '../data/services/favorites_local_service.dart';
import '../data/services/user_firebase_service.dart';
import '../presentation/view_models/splash_view_model.dart';
import '../presentation/view_models/onboarding_view_model.dart';
import '../presentation/view_models/login_view_model.dart';
import '../presentation/view_models/registration_view_model.dart';
import '../presentation/view_models/gallery_view_model.dart';
import '../presentation/view_models/detail_view_model.dart';
import '../presentation/view_models/favorites_view_model.dart';

final getIt = GetIt.instance;

/// Configura todas as injeções de dependência do projeto.
void setupDependencyInjections() {
  // Services
  getIt.registerLazySingleton(() => NasaApiService());
  getIt.registerLazySingleton(() => AuthLocalService());
  getIt.registerLazySingleton(() => AuthFirebaseService());
  getIt.registerLazySingleton(() => FavoritesLocalService());
  getIt.registerLazySingleton(() => UserFirebaseService());

  // Repositories
  getIt.registerLazySingleton(
    () => AstronomyRepository(
      getIt<NasaApiService>(),
      getIt<FavoritesLocalService>(),
    ),
  );
  getIt.registerLazySingleton(
    () =>
        AuthRepository(getIt<AuthFirebaseService>(), getIt<AuthLocalService>()),
  );
  getIt.registerLazySingleton(
    () => UserRepository(getIt<UserFirebaseService>()),
  );

  // ViewModels
  getIt.registerFactory(() => SplashViewModel(getIt<AuthRepository>()));
  getIt.registerFactory(() => OnboardingViewModel());
  getIt.registerFactory(() => LoginViewModel(getIt<AuthRepository>()));
  getIt.registerFactory(() => RegistrationViewModel(getIt<AuthRepository>()));
  getIt.registerFactory(() => GalleryViewModel(getIt<AstronomyRepository>()));
  getIt.registerFactory(() => DetailViewModel(getIt<AstronomyRepository>()));
  getIt.registerFactory(() => FavoritesViewModel(getIt<AstronomyRepository>()));
}
