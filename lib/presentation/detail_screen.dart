import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import 'view_models/detail_view_model.dart';
import 'view_models/gallery_view_model.dart';

/// Tela de Detalhes de uma astronomia.
/// Equivalente ao AstronomyDetailScreen.kt do projeto Kotlin.
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ CORREÇÃO: Aguarda o build terminar antes de carregar os dados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final date = ModalRoute.of(context)?.settings.arguments as String?;
      if (date != null) {
        // Carregar dados somente na primeira vez
        final viewModel = context.read<DetailViewModel>();
        if (viewModel.uiState == UiState.initial) {
          viewModel.loadAstronomy(date);
        }
      }
    });
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryDark,
                  AppTheme.secondaryDark,
                  AppTheme.surfaceDark,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context, viewModel),

                  // Content
                  Expanded(child: _buildContent(context, viewModel)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          ),
          Text(
            'APOD 2025',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: viewModel.astronomy != null
                ? () => viewModel.toggleFavorite()
                : null,
            icon: Icon(
              viewModel.astronomy?.isFavorite == true
                  ? Icons.star
                  : Icons.star_outline,
              color: viewModel.astronomy?.isFavorite == true
                  ? AppTheme.starYellow
                  : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, DetailViewModel viewModel) {
    switch (viewModel.uiState) {
      case UiState.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.cyanAccent),
              SizedBox(height: 16),
              Text('Carregando...', style: TextStyle(color: Colors.white54)),
            ],
          ),
        );

      case UiState.error:
        final date = ModalRoute.of(context)?.settings.arguments as String?;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppTheme.errorRed,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage,
                style: const TextStyle(color: AppTheme.errorRed),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  if (date != null) viewModel.loadAstronomy(date);
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        );

      case UiState.success:
      case UiState.initial:
        if (viewModel.astronomy == null) {
          return const SizedBox.shrink();
        }

        final astronomy = viewModel.astronomy!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        astronomy.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.white.withValues(alpha: .05),
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 64,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppTheme.primaryDark.withValues(alpha: .8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Details
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppTheme.cyanAccent.withValues(alpha: .8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(astronomy.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: .7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      astronomy.title,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 20),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .06),
                        ),
                      ),
                      child: Text(
                        astronomy.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.white.withValues(alpha: .7),
                        ),
                      ),
                    ),

                    // Copyright
                    if (astronomy.copyright != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Copyright: ${astronomy.copyright}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: .4),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }
}
