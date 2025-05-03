import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BudgetProgress extends StatelessWidget {
  final double spent;
  final double total;
  final String? label;
  final Color? progressColor;
  final Color? backgroundColor;

  const BudgetProgress({
    super.key,
    required this.spent,
    required this.total,
    this.label,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (spent / total).clamp(0.0, 1.0) : 0.0;
    final color = progressColor ?? AppColors.primary;
    final bgColor = backgroundColor ?? AppColors.grey200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label!, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  '${percentage * 100}%',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: constraints.maxWidth * percentage,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gastado: \$${spent.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
            ),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
            ),
          ],
        ),
      ],
    );
  }
}
