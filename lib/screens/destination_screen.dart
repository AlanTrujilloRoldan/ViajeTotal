import 'package:flutter/material.dart';
import '../services/destination_service.dart';
import '../widgets/destination_card.dart';
import '../widgets/category_chip.dart';
import '../models/destination.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DestinationService _destinationService = DestinationService();
  late Future<List<Destination>> _allDestinationsFuture;
  List<Destination> _filteredDestinations = [];
  bool _isSearching = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _allDestinationsFuture = _destinationService.getPopularDestinations();
    _filteredDestinations = [];

    // Obtener la categoría seleccionada de los argumentos de ruta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['category'] != null) {
        _filterByCategory(args['category']);
      }
    });
  }

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredDestinations = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final allDestinations = await _allDestinationsFuture;

    setState(() {
      _filteredDestinations =
          allDestinations.where((destination) {
            final nameLower = destination.name.toLowerCase();
            final locationLower = destination.location.toLowerCase();
            final tagsLower = destination.tags.join(' ').toLowerCase();
            final queryLower = query.toLowerCase();

            return nameLower.contains(queryLower) ||
                locationLower.contains(queryLower) ||
                tagsLower.contains(queryLower);
          }).toList();
      _isSearching = false;
    });
  }

  Future<void> _filterByCategory(String? category) async {
    setState(() {
      _selectedCategory = category;
      _isSearching = true;
    });

    final allDestinations = await _allDestinationsFuture;

    setState(() {
      _filteredDestinations =
          category == null
              ? allDestinations
              : allDestinations
                  .where((d) => d.tags.contains(category))
                  .toList();
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explorar")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "¿A dónde quieres ir?",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _search,
              onSubmitted: _search,
            ),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryChip(
                    label: 'Todos',
                    isSelected: _selectedCategory == null,
                    onSelected: () => _filterByCategory(null),
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Playas',
                    isSelected: _selectedCategory == 'Playa',
                    onSelected: () => _filterByCategory('Playa'),
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Aventura',
                    isSelected: _selectedCategory == 'Aventura',
                    onSelected: () => _filterByCategory('Aventura'),
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Cultural',
                    isSelected: _selectedCategory == 'Cultural',
                    onSelected: () => _filterByCategory('Cultural'),
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Naturaleza',
                    isSelected: _selectedCategory == 'Naturaleza',
                    onSelected: () => _filterByCategory('Naturaleza'),
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Gastronomía',
                    isSelected: _selectedCategory == 'Gastronomía',
                    onSelected: () => _filterByCategory('Gastronomía'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_isSearching)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_filteredDestinations.isNotEmpty)
              Expanded(child: _buildDestinationsList(_filteredDestinations))
            else if (_searchController.text.isNotEmpty && !_isSearching)
              const Expanded(
                child: Center(child: Text("No se encontraron destinos")),
              )
            else
              FutureBuilder<List<Destination>>(
                future: _allDestinationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Expanded(
                      child: Center(child: Text('No hay destinos disponibles')),
                    );
                  }

                  return Expanded(
                    child: _buildDestinationsList(snapshot.data!),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationsList(List<Destination> destinations) {
    return ListView.separated(
      itemCount: destinations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return DestinationCard(
          destination: destinations[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              '/destination',
              arguments: destinations[index],
            );
          },
        );
      },
    );
  }
}
