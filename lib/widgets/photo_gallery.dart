import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> imageUrls;
  final ValueChanged<int>? onPhotoTap;
  final double spacing;
  final int maxPreviewPhotos;

  const PhotoGallery({
    super.key,
    required this.imageUrls,
    this.onPhotoTap,
    this.spacing = 4,
    this.maxPreviewPhotos = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size =
            (constraints.maxWidth - spacing * (maxPreviewPhotos - 1)) /
            maxPreviewPhotos;

        return SizedBox(
          height: size,
          child: Stack(
            children: [
              // Fotos visibles
              ...imageUrls.take(maxPreviewPhotos).toList().asMap().entries.map((
                entry,
              ) {
                final index = entry.key;
                final url = entry.value;
                final left = index * (size + spacing);

                return Positioned(
                  left: left,
                  child: _buildPhotoItem(url, size, index),
                );
              }),

              // Contador de fotos restantes
              if (imageUrls.length > maxPreviewPhotos)
                Positioned(
                  right: 0,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(13),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '+${imageUrls.length - maxPreviewPhotos}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoItem(String url, double size, int index) {
    return GestureDetector(
      onTap: () => onPhotoTap?.call(index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: size,
          height: size,
          color: AppColors.grey200,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, color: AppColors.grey400);
            },
          ),
        ),
      ),
    );
  }
}
