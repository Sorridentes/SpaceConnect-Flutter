import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import 'view_models/onboarding_view_model.dart';

/// Tela de Onboarding com PageView.
/// Equivalente ao AstronomyOnboardingScreen.kt do projeto Kotlin.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: const _OnboardingContent(),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              AppTheme.secondaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Botão Pular
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Pular',
                      style: TextStyle(
                        color: AppTheme.cyanAccent.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: viewModel.pageController,
                  onPageChanged: viewModel.onPageChanged,
                  itemCount: viewModel.pages.length,
                  itemBuilder: (context, index) {
                    final page = viewModel.pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Imagem
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              page.imageUrl,
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 64,
                                  color: Colors.white24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Título
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 16),
                          // Descrição
                          Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white60,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Indicadores + Botão
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Indicadores de página
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        viewModel.pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: viewModel.currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: viewModel.currentPage == index
                                ? AppTheme.cyanAccent
                                : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Botão
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (viewModel.isLastPage) {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.login);
                          } else {
                            viewModel.nextPage();
                          }
                        },
                        child: Text(
                          viewModel.isLastPage ? 'Começar' : 'Próximo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
