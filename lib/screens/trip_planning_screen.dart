import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/destination.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';
import '../widgets/destination_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/tag_selector.dart';
import '../widgets/budget_progress.dart';

class TripPlanningScreen extends StatefulWidget {
  const TripPlanningScreen({super.key});

  @override
  State<TripPlanningScreen> createState() => _TripPlanningScreenState();
}

class _TripPlanningScreenState extends State<TripPlanningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController(text: '1000');

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  List<String> _selectedTags = ['Vacaciones'];
  final List<Destination> _selectedDestinations = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificar viaje'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving ? null : _saveTrip,
          ),
        ],
      ),
      body:
          _isSaving
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(),
                      const SizedBox(height: 24),
                      _buildDatesSection(),
                      const SizedBox(height: 24),
                      _buildBudgetSection(),
                      const SizedBox(height: 24),
                      _buildTagsSection(),
                      const SizedBox(height: 24),
                      _buildDestinationsSection(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Título del viaje',
            prefixIcon: Icon(Icons.flag),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un título';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fechas del viaje',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildDatePicker('Inicio', _startDate, true)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('a'),
            ),
            Expanded(child: _buildDatePicker('Fin', _endDate, false)),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, bool isStartDate) {
    return InkWell(
      onTap: () => _selectDate(context, isStartDate: isStartDate),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(DateFormat('dd/MM/yyyy').format(date)),
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Presupuesto estimado',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _budgetController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.attach_money),
            hintText: 'Ingresa tu presupuesto',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un presupuesto';
            }
            if (double.tryParse(value) == null) {
              return 'Ingresa un número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        BudgetProgress(
          spent: 0,
          total: double.tryParse(_budgetController.text) ?? 1000,
          label: 'Presupuesto disponible',
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return TagSelector(
      availableTags: const [
        'Vacaciones',
        'Negocios',
        'Aventura',
        'Familiar',
        'Romántico',
      ],
      selectedTags: _selectedTags,
      onChanged: (tags) {
        setState(() {
          _selectedTags = tags;
        });
      },
      label: 'Categorías del viaje',
    );
  }

  Widget _buildDestinationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Destinos seleccionados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _selectedDestinations.isEmpty
            ? _buildAddDestinationButton()
            : Column(
              children: [
                ..._selectedDestinations.map((destination) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DestinationCard(
                      destination: destination,
                      onTap: () => _showDestinationDetails(destination),
                    ),
                  );
                }),
                _buildAddDestinationButton(),
              ],
            ),
      ],
    );
  }

  Widget _buildAddDestinationButton() {
    return OutlinedButton.icon(
      onPressed: _searchDestinations,
      icon: const Icon(Icons.add),
      label: const Text('Agregar destino'),
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
    );
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _searchDestinations() async {
    final Destination? selected = await showDialog<Destination>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Buscar destinos'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomSearchBar(hintText: 'Buscar destinos...'),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        // Aquí iría la lista de resultados de búsqueda real
                        _buildDestinationListItem('Playa del Carmen', 'México'),
                        _buildDestinationListItem('Cancún', 'México'),
                        _buildDestinationListItem('Tulum', 'México'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );

    if (selected != null) {
      setState(() {
        _selectedDestinations.add(selected);
      });
    }
  }

  ListTile _buildDestinationListItem(String name, String location) {
    return ListTile(
      title: Text(name),
      subtitle: Text(location),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(
          context,
          Destination(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            description: 'Descripción de ejemplo para $name',
            location: location,
            latitude: 0,
            longitude: 0,
            imageUrls: ['https://example.com/image.jpg'],
            tags: [],
            averageRating: 4.5,
            reviewCount: 100,
          ),
        );
      },
    );
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDestinations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un destino')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final newTrip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      budget: double.tryParse(_budgetController.text) ?? 0,
      destinationIds: _selectedDestinations.map((d) => d.id).toList(),
      participantIds: ['current_user_id'],
      coverImageUrl: _selectedDestinations.first.imageUrls.firstOrNull ?? '',
    );

    try {
      await Provider.of<TripService>(
        context,
        listen: false,
      ).createTrip(newTrip);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Viaje creado exitosamente!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showDestinationDetails(Destination destination) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(destination.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  destination.imageUrls.firstOrNull ??
                      'https://via.placeholder.com/150',
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(destination.description),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDestinations.remove(destination);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
