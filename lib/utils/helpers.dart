import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class FormatHelper {
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    ).format(amount);
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return '$hours:$minutes';
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
}

class UIHelper {
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<void> showLoadingDialog(
    BuildContext context, {
    String? message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(message ?? 'Cargando...'),
              ],
            ),
          ),
    );
  }

  static void showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? actionText,
    VoidCallback? onAction,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              if (actionText != null)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onAction?.call();
                  },
                  child: Text(actionText),
                ),
            ],
          ),
    );
  }
}

class ValidationHelper {
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    ).hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidTripDateRange(DateTime start, DateTime end) {
    return end.isAfter(start);
  }
}

class CalculationHelper {
  static double calculateTripProgress(DateTime startDate, DateTime endDate) {
    final totalDays = endDate.difference(startDate).inDays;
    final daysPassed = DateTime.now().difference(startDate).inDays;
    return (daysPassed / totalDays).clamp(0.0, 1.0);
  }

  static double calculateBudgetUsage(double spent, double totalBudget) {
    return (spent / totalBudget).clamp(0.0, 1.0);
  }

  static String getTripStatus(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 'Planificado';
    if (now.isAfter(endDate)) return 'Completado';
    return 'En progreso';
  }
}

class ImageHelper {
  static String getPlaceholderImageUrl(String category) {
    const baseUrl = 'https://tuviajetotal.com/placeholders';
    switch (category.toLowerCase()) {
      case 'aventura':
        return '$baseUrl/adventure.jpg';
      case 'playa':
        return '$baseUrl/beach.jpg';
      case 'ciudad':
        return '$baseUrl/city.jpg';
      case 'montaña':
        return '$baseUrl/mountain.jpg';
      default:
        return '$baseUrl/general.jpg';
    }
  }
}
