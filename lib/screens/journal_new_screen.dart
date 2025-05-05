import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/journal_entry.dart';
import '../widgets/map_preview.dart';
import '../widgets/tag_selector.dart';
import '../utils/helpers.dart';

class JournalEntryNewScreen extends StatefulWidget {
  final String tripId;
  final Function(JournalEntry) onSave;

  const JournalEntryNewScreen({
    super.key,
    required this.tripId,
    required this.onSave,
  });

  @override
  State<JournalEntryNewScreen> createState() => _JournalEntryNewScreenState();
}

class _JournalEntryNewScreenState extends State<JournalEntryNewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _locationController = TextEditingController();

  List<String> _selectedTags = [];
  final List<String> _imageUrls = [];
  double? _latitude;
  double? _longitude;
  DateTime _entryDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva entrada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
            tooltip: 'Guardar entrada',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fecha
              _buildDateField(),
              const SizedBox(height: 16),

              // Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contenido
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contenido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ubicación
              _buildLocationField(),
              const SizedBox(height: 16),

              // Mapa (si hay coordenadas)
              if (_latitude != null && _longitude != null)
                Column(
                  children: [
                    MapPreview(
                      location: LatLng(_latitude!, _longitude!),
                      height: 150,
                      markerTitle: _locationController.text,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _clearLocation,
                      child: const Text('Eliminar ubicación'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Etiquetas
              TagSelector(
                availableTags: const [
                  'Aventura',
                  'Comida',
                  'Cultura',
                  'Naturaleza',
                  'Relax',
                  'Familiar',
                  'Amigos',
                  'Trabajo',
                ],
                selectedTags: _selectedTags,
                onChanged: (tags) {
                  setState(() {
                    _selectedTags = tags;
                  });
                },
                label: 'Etiquetas',
              ),
              const SizedBox(height: 16),

              // Imágenes
              _buildImageSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fecha',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(FormatHelper.formatDate(_entryDate, format: 'EEEE, d MMMM y')),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Ubicación',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.map),
          onPressed: _selectLocationOnMap,
          tooltip: 'Seleccionar en mapa',
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imágenes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        if (_imageUrls.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUrls.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _imageUrls[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

        TextButton.icon(
          onPressed: _addImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Agregar imágenes'),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _entryDate) {
      setState(() {
        _entryDate = picked;
      });
    }
  }

  Future<void> _selectLocationOnMap() async {
    final LatLng? selectedLocation = await showDialog<LatLng>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Seleccionar ubicación'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(20.629559, -87.073885),
                  zoom: 14,
                ),
                onTap: (latLng) => Navigator.pop(context, latLng),
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

    if (selectedLocation != null) {
      setState(() {
        _latitude = selectedLocation.latitude;
        _longitude = selectedLocation.longitude;
        _locationController.text = 'Ubicación seleccionada';
      });
    }
  }

  void _clearLocation() {
    setState(() {
      _latitude = null;
      _longitude = null;
      _locationController.clear();
    });
  }

  Future<void> _addImages() async {
    final List<String>? newImages = await showDialog<List<String>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar imágenes'),
            content: const Text('Selecciona imágenes de tu galería'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pop(context, [
                      'https://example.com/new_image1.jpg',
                      'https://example.com/new_image2.jpg',
                    ]),
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );

    if (newImages != null && newImages.isNotEmpty) {
      setState(() {
        _imageUrls.addAll(newImages);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  void _saveEntry() {
    if (!_formKey.currentState!.validate()) return;

    final newEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tripId: widget.tripId,
      date: _entryDate,
      title: _titleController.text,
      content: _contentController.text,
      imageUrls: _imageUrls,
      location: _locationController.text,
      latitude: _latitude,
      longitude: _longitude,
      tags: _selectedTags,
    );

    widget.onSave(newEntry);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
