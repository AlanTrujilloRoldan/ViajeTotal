import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/journal_entry.dart';
import '../widgets/map_preview.dart';
import '../models/journal_entry.dart';
import '../models/trip.dart';
import '../theme/colors.dart';

class TravelJournalScreen extends StatefulWidget {
  final Trip trip;

  const TravelJournalScreen({super.key, required this.trip});

  @override
  State<TravelJournalScreen> createState() => _TravelJournalScreenState();
}

class _TravelJournalScreenState extends State<TravelJournalScreen> {
  final List<JournalEntry> _entries = [
    JournalEntry(
      id: '1',
      tripId: '1',
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Primer día en la playa',
      content:
          'Hoy llegamos a nuestro destino. El hotel es espectacular con vista al mar...',
      imageUrls: [
        'https://example.com/beach1.jpg',
        'https://example.com/beach2.jpg',
      ],
      location: 'Playa del Carmen, México',
      latitude: 20.629559,
      longitude: -87.073885,
      tags: ['Playa', 'Llegada', 'Hotel'],
    ),
    // Más entradas...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diario: ${widget.trip.title}'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addNewEntry),
        ],
      ),
      body: _entries.isEmpty ? _buildEmptyState() : _buildJournalList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          const Text(
            'No hay entradas en tu diario',
            style: TextStyle(fontSize: 18, color: AppColors.grey600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Presiona el botón + para agregar una nueva entrada',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey500),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _addNewEntry,
            child: const Text('Crear primera entrada'),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Resumen del viaje
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen del viaje',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                // Mapa con ubicaciones
                if (_entries.any(
                  (e) => e.latitude != null && e.longitude != null,
                ))
                  Column(
                    children: [
                      MapPreview(
                        location: LatLng(
                          _entries
                              .firstWhere(
                                (e) =>
                                    e.latitude != null && e.longitude != null,
                              )
                              .latitude!,
                          _entries
                              .firstWhere(
                                (e) =>
                                    e.latitude != null && e.longitude != null,
                              )
                              .longitude!,
                        ),
                        height: 150,
                        markerTitle: 'Tu viaje',
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                // Estadísticas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.photo_library,
                      value:
                          _entries
                              .fold(
                                0,
                                (sum, entry) => sum + entry.imageUrls.length,
                              )
                              .toString(),
                      label: 'Fotos',
                    ),
                    _buildStatItem(
                      icon: Icons.place,
                      value:
                          _entries
                              .where((e) => e.location.isNotEmpty)
                              .length
                              .toString(),
                      label: 'Lugares',
                    ),
                    _buildStatItem(
                      icon: Icons.calendar_today,
                      value:
                          '${widget.trip.startDate.day}/${widget.trip.startDate.month} - ${widget.trip.endDate.day}/${widget.trip.endDate.month}',
                      label: 'Días',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Lista de entradas
        ..._entries.map(
          (entry) => JournalEntryWidget(
            entry: entry,
            onTap: () {
              _viewEntryDetails(entry);
            },
            isEditable: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.grey600),
        ),
      ],
    );
  }

  void _addNewEntry() {
    // Navegar a pantalla de creación de entrada
  }

  void _viewEntryDetails(JournalEntry entry) {
    // Navegar a pantalla de detalles/edición
  }
}
