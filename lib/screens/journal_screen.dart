import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/journal_service.dart';
import '../widgets/journal_entry_widget.dart';
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
  final JournalService _journalService = JournalService();
  late Future<List<JournalEntry>> _entriesFuture;
  //List<JournalEntry> _entries = []; // Local cache of entries

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    _entriesFuture = _journalService.getJournalEntries(widget.trip.id);
    _entriesFuture.then((entries) {
      setState(() {
        //_entries = entries;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diario: ${widget.trip.title}'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addNewEntry),
        ],
      ),
      body: FutureBuilder<List<JournalEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return _buildEmptyState();
          }

          return _buildJournalList(entries);
        },
      ),
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

  Widget _buildJournalList(List<JournalEntry> entries) {
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
                if (entries.any(
                  (e) => e.latitude != null && e.longitude != null,
                ))
                  Column(
                    children: [
                      MapPreview(
                        location: LatLng(
                          entries
                                  .firstWhere(
                                    (e) =>
                                        e.latitude != null &&
                                        e.longitude != null,
                                    orElse: () => entries.first,
                                  )
                                  .latitude ??
                              0,
                          entries
                                  .firstWhere(
                                    (e) =>
                                        e.latitude != null &&
                                        e.longitude != null,
                                    orElse: () => entries.first,
                                  )
                                  .longitude ??
                              0,
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
                          entries
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
                          entries
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
        ...entries.map(
          (entry) => JournalEntryWidget(
            entry: entry,
            onTap: () => _viewEntryDetails(entry),
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

  void _addNewEntry() async {
    final newEntry = await Navigator.pushNamed(
      context,
      '/journal_entry_new',
      arguments: {'tripId': widget.trip.id},
    );

    if (newEntry != null && newEntry is JournalEntry) {
      await _journalService.createJournalEntry(newEntry);
      _loadEntries(); // Refresh the list
    }
  }

  void _viewEntryDetails(JournalEntry entry) async {
    final result = await Navigator.pushNamed(
      context,
      '/journal_entry_edit',
      arguments: entry,
    );

    if (result != null && result is JournalEntry) {
      await _journalService.updateJournalEntry(result);
      _loadEntries(); // Refresh the list
    } else if (result == 'deleted') {
      await _journalService.deleteJournalEntry(entry.id);
      _loadEntries(); // Refresh the list
    }
  }
}
