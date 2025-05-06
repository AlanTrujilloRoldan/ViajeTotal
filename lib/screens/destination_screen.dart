import 'package:flutter/material.dart';
import '../services/destination_service.dart';
import '../widgets/destination_card.dart';
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

  @override
  void initState() {
    super.initState();
    _allDestinationsFuture = _destinationService.getPopularDestinations();
    _filteredDestinations = [];
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
            const SizedBox(height: 20),
            if (_isSearching)
              const Center(child: CircularProgressIndicator())
            else if (_filteredDestinations.isNotEmpty)
              Expanded(child: _buildSearchResults())
            else if (_searchController.text.isNotEmpty && !_isSearching)
              const Center(child: Text("No se encontraron destinos"))
            else
              FutureBuilder<List<Destination>>(
                future: _allDestinationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay destinos disponibles'),
                    );
                  }

                  return Expanded(child: _buildAllDestinations(snapshot.data!));
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _filteredDestinations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DestinationCard(
            destination: _filteredDestinations[index],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/destination',
                arguments: _filteredDestinations[index],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAllDestinations(List<Destination> destinations) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Destinos populares',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 16),
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
          ),
        ],
      ),
    );
  }
}
