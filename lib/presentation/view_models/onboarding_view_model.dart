import 'package:flutter/material.dart';
import '../../domain/models/onboarding_page_model.dart';

/// ViewModel da tela de Onboarding.
/// Equivalente ao OnboardingContent do projeto Kotlin.
class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  final List<OnboardingPageModel> pages = const [
    OnboardingPageModel(
      title: 'Explore o Universo',
      description:
          'Descubra as maravilhas do cosmos com imagens diárias capturadas pela NASA.',
      imageUrl:
          'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=800',
    ),
    OnboardingPageModel(
      title: 'Imagem do Dia',
      description:
          'Acesse a Astronomy Picture of the Day (APOD) e aprenda sobre nebulosas, galáxias e mais.',
      imageUrl:
          'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=800',
    ),
    OnboardingPageModel(
      title: 'Salve seus Favoritos',
      description:
          'Marque suas imagens preferidas e crie sua coleção pessoal de maravilhas cósmicas.',
      imageUrl:
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800',
    ),
    OnboardingPageModel(
      title: 'Comece sua Jornada',
      description:
          'Crie sua conta e embarque nessa viagem pelo espaço sideral.',
      imageUrl:
          'https://images.unsplash.com/photo-1516339901601-2e1b62dc0c45?w=800',
    ),
  ];

  bool get isLastPage => _currentPage == pages.length - 1;

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
