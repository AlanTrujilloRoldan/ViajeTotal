import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;
  final bool showCount;

  const RatingBar({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 20,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: AppColors.secondary, size: size),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size * 0.6, fontWeight: FontWeight.bold),
        ),
        if (showCount && reviewCount > 0) ...[
          const SizedBox(width: 8),
          Text(
            '($reviewCount)',
            style: TextStyle(fontSize: size * 0.5, color: AppColors.grey600),
          ),
        ],
      ],
    );
  }
}
