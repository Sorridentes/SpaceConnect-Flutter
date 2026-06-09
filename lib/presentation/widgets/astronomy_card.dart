import 'package:cached_network_image/cached_network_image.dart';
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

  /// Verifica se a URL é de um vídeo (YouTube ou Vimeo)
  bool _isVideoUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('vimeo.com');
  }

  /// Obtém a thumbnail do vídeo (se for vídeo)
  String? _getVideoThumbnail(String url) {
    // YouTube thumbnail
    if (url.contains('youtube.com/watch?v=')) {
      final videoId = url.split('v=')[1].split('&')[0];
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    // youtu.be short URL
    if (url.contains('youtu.be/')) {
      final videoId = url.split('youtu.be/')[1].split('?')[0];
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    return null;
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
            // Thumbnail com suporte a diferentes tipos de mídia
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: _buildThumbnail(),
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
                    // Indicador de vídeo (se for vídeo)
                    if (astronomy.mediaType == 'video' ||
                        _isVideoUrl(astronomy.image))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              size: 12,
                              color: AppTheme.cyanAccent.withValues(alpha: .6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Vídeo',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppTheme.cyanAccent.withValues(
                                  alpha: .6,
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

  /// Constrói o thumbnail apropriado baseado no tipo de mídia
  Widget _buildThumbnail() {
    // Verifica se é vídeo
    if (astronomy.mediaType == 'video' || _isVideoUrl(astronomy.image)) {
      final thumbnailUrl = _getVideoThumbnail(astronomy.image);
      if (thumbnailUrl != null) {
        return Stack(
          children: [
            Image.network(
              thumbnailUrl,
              width: 180,
              height: 190,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildPlaceholder(),
            ),
            Container(
              width: 180,
              height: 190,
              color: Colors.black.withValues(alpha: .3),
              child: const Center(
                child: Icon(
                  Icons.play_circle_filled,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      }
      return _buildVideoPlaceholder();
    }

    // É imagem - tenta diferentes URLs
    final imageUrl = _getValidImageUrl();
    if (imageUrl == null) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: astronomy.image,
      width: 180,
      height: 190,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.white.withValues(alpha: .05),
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => _buildPlaceholder(),
    );
  }

  /// Retorna a URL de imagem válida (tenta diferentes campos)
  String? _getValidImageUrl() {
    // Tenta usar hdImage primeiro (melhor qualidade)
    if (astronomy.hdImage != null && astronomy.hdImage!.isNotEmpty) {
      return astronomy.hdImage;
    }
    // Depois a image padrão
    if (astronomy.image.isNotEmpty) {
      return astronomy.image;
    }
    return null;
  }

  /// Placeholder para imagens normais
  Widget _buildPlaceholder() {
    return Container(
      width: 180,
      height: 190,
      color: Colors.white.withValues(alpha: .05),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 32,
            color: Colors.white24,
          ),
          SizedBox(height: 8),
          Text(
            'Imagem\nindisponível',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.white24),
          ),
        ],
      ),
    );
  }

  /// Placeholder para vídeos
  Widget _buildVideoPlaceholder() {
    return Container(
      width: 180,
      height: 190,
      color: Colors.white.withValues(alpha: .05),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off_outlined, size: 32, color: Colors.white24),
          SizedBox(height: 8),
          Text(
            'Vídeo\nnão disponível',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.white24),
          ),
        ],
      ),
    );
  }
}
