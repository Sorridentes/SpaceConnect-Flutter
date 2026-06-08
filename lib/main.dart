// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/dependency_injections.dart';
import 'core/firebase_initializer.dart';
import 'core/app_theme.dart';
import 'core/app_routes.dart';
import 'presentation/splash_screen.dart';
import 'presentation/onboarding_screen.dart';
import 'presentation/login_screen.dart';
import 'presentation/registration_screen.dart';
import 'presentation/gallery_screen.dart';
import 'presentation/detail_screen.dart';
import 'presentation/favorites_screen.dart';
import 'presentation/view_models/splash_view_model.dart';
import 'presentation/view_models/login_view_model.dart';
import 'presentation/view_models/registration_view_model.dart';
import 'presentation/view_models/gallery_view_model.dart';
import 'presentation/view_models/detail_view_model.dart';
import 'presentation/view_models/favorites_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseInitializer.initialize();

  setupDependencyInjections();
  runApp(const SpaceConnectApp());
}

/// Aplicativo principal SpaceConnect.
class SpaceConnectApp extends StatelessWidget {
  const SpaceConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<SplashViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<LoginViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<RegistrationViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<GalleryViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<DetailViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<FavoritesViewModel>()),
      ],
      child: MaterialApp(
        title: 'SpaceConnect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.onboarding: (context) => const OnboardingScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.registration: (context) => const RegistrationScreen(),
          AppRoutes.gallery: (context) => const GalleryScreen(),
          AppRoutes.detail: (context) => const DetailScreen(),
          AppRoutes.favorites: (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}
