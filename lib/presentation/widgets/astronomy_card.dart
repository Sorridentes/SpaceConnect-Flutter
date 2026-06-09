import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_theme.dart';
import '../../domain/models/astronomy_model.dart';

/// Widget de card para exibir um item de astronomia.
/// Equivalente ao AstronomyCard.kt do projeto Kotlin.
class AstronomyCard extends StatelessWidget {
  final AstronomyModel astronomy;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const AstronomyCard({
    super.key,
    required this.astronomy,
    required this.onTap,
    required this.onFavorite,
  });

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date).toUpperCase();
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: .06)),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                astronomy.image,
                width: 180,
                height: 190,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 180,
                  height: 190,
                  color: Colors.white.withValues(alpha: .05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.white.withValues(alpha: .3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Erro ao carregar imagem',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: .3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data
                    Text(
                      _formatDate(astronomy.date),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppTheme.cyanAccent.withValues(alpha: .8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Título
                    Text(
                      astronomy.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Descrição
                    Text(
                      astronomy.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: .5),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Botão Favorito
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  astronomy.isFavorite ? Icons.star : Icons.star_outline,
                  color: astronomy.isFavorite
                      ? AppTheme.starYellow
                      : Colors.white38,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
