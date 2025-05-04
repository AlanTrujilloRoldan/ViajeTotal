import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ActivityIndicator extends StatelessWidget {
  final bool isActive;
  final String activeText;
  final String inactiveText;
  final VoidCallback? onTap;
  final Color? activeColor;
  final Color? inactiveColor;

  const ActivityIndicator({
    super.key,
    required this.isActive,
    this.activeText = 'Activo ahora',
    this.inactiveText = 'Inactivo',
    this.onTap,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.success.withAlpha(51) : AppColors.grey300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.success : AppColors.grey600,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              isActive ? activeText : inactiveText,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppColors.success : AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
