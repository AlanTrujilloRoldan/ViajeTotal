import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../widgets/activity_indicator.dart';
import '../widgets/budget_progress.dart';
import '../theme/colors.dart';
import '../utils/helpers.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  // Lista de viajes de ejemplo (en una app real vendría de tu servicio)
  final List<Trip> _trips = [
    Trip(
      id: '1',
      title: 'Vacaciones en Cancún',
      description: 'Viaje familiar a la playa',
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      budget: 2500.0,
      destinationIds: ['1', '2'],
      participantIds: ['user1', 'user2'],
      coverImageUrl: 'https://example.com/cancun.jpg',
    ),
    Trip(
      id: '2',
      title: 'Aventura en Chiapas',
      description: 'Tour por la selva y ruinas',
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      budget: 1800.0,
      destinationIds: ['3', '4'],
      participantIds: ['user1'],
      coverImageUrl: 'https://example.com/chiapas.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Viajes'), centerTitle: true),
      body: Column(
        children: [
          // Botón grande para añadir viaje
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToAddTrip,
                icon: const Icon(Icons.add, size: 24),
                label: const Text(
                  'Añadir viaje',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Lista de viajes
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _trips.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildTripCard(_trips[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    final progress = CalculationHelper.calculateTripProgress(
      trip.startDate,
      trip.endDate,
    );
    final status = CalculationHelper.getTripStatus(
      trip.startDate,
      trip.endDate,
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _viewTripDetails(trip),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con imagen y estado
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        trip.coverImageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder:
                            (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ActivityIndicator(
                      isActive: status == 'En progreso',
                      activeText: 'En progreso',
                      inactiveText: status,
                      activeColor: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Información del viaje
              Text(
                trip.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                trip.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),

              // Fechas
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${FormatHelper.formatDate(trip.startDate)} - '
                    '${FormatHelper.formatDate(trip.endDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progreso y presupuesto
              BudgetProgress(
                spent: trip.budget * progress,
                total: trip.budget,
                label: 'Presupuesto',
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: AppColors.primary,
                minHeight: 6,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% completado',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${trip.destinationIds.length} destinos',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddTrip() {
    Navigator.pushNamed(context, '/plan-trip');
  }

  void _viewTripDetails(Trip trip) {
    Navigator.pushNamed(context, '/journal', arguments: trip);
  }
}
