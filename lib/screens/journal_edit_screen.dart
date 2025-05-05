import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/journal_entry.dart';
import '../widgets/map_preview.dart';
import '../widgets/tag_selector.dart';
import '../utils/helpers.dart';

class JournalEntryEditScreen extends StatefulWidget {
  final JournalEntry entry;
  final Function(JournalEntry) onUpdate;
  final Function(String) onDelete;

  const JournalEntryEditScreen({
    super.key,
    required this.entry,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<JournalEntryEditScreen> createState() => _JournalEntryEditScreenState();
}

class _JournalEntryEditScreenState extends State<JournalEntryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _locationController;

  late List<String> _selectedTags;
  late List<String> _imageUrls;
  late double? _latitude;
  late double? _longitude;
  late DateTime _entryDate;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los valores de la entrada existente
    _titleController = TextEditingController(text: widget.entry.title);
    _contentController = TextEditingController(text: widget.entry.content);
    _locationController = TextEditingController(text: widget.entry.location);

    _selectedTags = List.from(widget.entry.tags);
    _imageUrls = List.from(widget.entry.imageUrls);
    _latitude = widget.entry.latitude;
    _longitude = widget.entry.longitude;
    _entryDate = widget.entry.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar entrada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
            tooltip: 'Eliminar entrada',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateEntry,
            tooltip: 'Guardar cambios',
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
          label: const Text('Agregar más imágenes'),
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
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _latitude ?? 20.629559,
                    _longitude ?? -87.073885,
                  ),
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
        _locationController.text =
            _locationController.text.isEmpty
                ? 'Ubicación seleccionada'
                : _locationController.text;
      });
    }
  }

  void _clearLocation() {
    setState(() {
      _latitude = null;
      _longitude = null;
    });
  }

  Future<void> _addImages() async {
    final List<String>? newImages = await showDialog<List<String>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar imágenes'),
            content: const Text(
              'Selecciona imágenes adicionales de tu galería',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pop(context, [
                      'https://example.com/additional_image1.jpg',
                      'https://example.com/additional_image2.jpg',
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

  void _updateEntry() {
    if (!_formKey.currentState!.validate()) return;

    final updatedEntry = JournalEntry(
      id: widget.entry.id,
      tripId: widget.entry.tripId,
      date: _entryDate,
      title: _titleController.text,
      content: _contentController.text,
      imageUrls: _imageUrls,
      location: _locationController.text,
      latitude: _latitude,
      longitude: _longitude,
      tags: _selectedTags,
    );

    widget.onUpdate(updatedEntry);
    Navigator.pop(context);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar entrada'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar esta entrada permanentemente?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  widget.onDelete(widget.entry.id);
                  Navigator.pop(context); // Cerrar diálogo de confirmación
                  Navigator.pop(context); // Cerrar pantalla de edición
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
