import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/destination.dart';
import '../theme/colors.dart';
import '../utils/helpers.dart';

class TripTimeline extends StatelessWidget {
  final Trip trip;
  final List<Destination> destinations;
  final ValueChanged<Destination>? onDestinationSelected;

  const TripTimeline({
    super.key,
    required this.trip,
    required this.destinations,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = trip.endDate.difference(trip.startDate).inDays + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Itinerario ($days días)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: days,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, dayIndex) {
            final currentDate = trip.startDate.add(Duration(days: dayIndex));
            final dayDestinations =
                destinations.where((d) {
                  // Lógica para filtrar destinos por día
                  return true; // Implementar lógica real según tu modelo
                }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado del día
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.grey300, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${dayIndex + 1}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Día ${dayIndex + 1}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            FormatHelper.formatDate(
                              currentDate,
                              format: 'EEEE, d MMMM',
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Lista de actividades del día
                if (dayDestinations.isNotEmpty)
                  ...dayDestinations.map(
                    (destination) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => onDestinationSelected?.call(destination),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    destination.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    destination.location,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (dayDestinations.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No hay actividades planeadas',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
