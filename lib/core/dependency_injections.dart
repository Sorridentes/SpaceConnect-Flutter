// lib/core/dependency_injections.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:space_connect/data/repositories/astronomy_repository.dart';
import 'package:space_connect/data/repositories/auth_repository.dart';
import 'package:space_connect/data/repositories/user_repository.dart';
import 'package:space_connect/data/services/auth_firebase_service.dart';
import 'package:space_connect/data/services/auth_local_service.dart';
import 'package:space_connect/data/services/favorites_local_service.dart';
import 'package:space_connect/data/services/nasa_api_service.dart';
import 'package:space_connect/data/services/user_firebase_service.dart';
import 'package:space_connect/presentation/view_models/detail_view_model.dart';
import 'package:space_connect/presentation/view_models/favorites_view_model.dart';
import 'package:space_connect/presentation/view_models/gallery_view_model.dart';
import 'package:space_connect/presentation/view_models/login_view_model.dart';
import 'package:space_connect/presentation/view_models/onboarding_view_model.dart';
import 'package:space_connect/presentation/view_models/registration_view_model.dart';

final getIt = GetIt.instance;

/// Configura todas as injeções de dependência do projeto.
void setupDependencyInjections() {
  // Firebase Instances
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Services
  getIt.registerLazySingleton(() => NasaApiService());
  getIt.registerLazySingleton(() => AuthLocalService());
  getIt.registerLazySingleton(() => FavoritesLocalService());
  getIt.registerLazySingleton(() => UserFirebaseService());
  getIt.registerLazySingleton(() => AuthFirebaseService(getIt<FirebaseAuth>()));

  // Repositories
  getIt.registerLazySingleton(
    () => AstronomyRepository(
      getIt<NasaApiService>(),
      getIt<FavoritesLocalService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => UserRepository(getIt<UserFirebaseService>()),
  );
  getIt.registerLazySingleton(
    () =>
        AuthRepository(getIt<AuthFirebaseService>(), getIt<AuthLocalService>()),
  );

  // ViewModels
  getIt.registerFactory(() => OnboardingViewModel());
  getIt.registerFactory(() => LoginViewModel(getIt<AuthRepository>()));
  getIt.registerFactory(() => RegistrationViewModel(getIt<AuthRepository>()));
  getIt.registerFactory(() => GalleryViewModel(getIt<AstronomyRepository>()));
  getIt.registerFactory(() => DetailViewModel(getIt<AstronomyRepository>()));
  getIt.registerFactory(() => FavoritesViewModel(getIt<AstronomyRepository>()));
}
