import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/destination.dart';
import '../widgets/photo_gallery.dart';
import '../widgets/map_preview.dart';
import '../widgets/rating_bar.dart' as custom_rating;
import '../theme/colors.dart';

class ReviewsPreviewSection extends StatelessWidget {
  const ReviewsPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Reseñas recientes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          trailing: TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/reviews',
                arguments: Destination(
                  id: 'temp',
                  name: 'Destino',
                  description: 'Descripción',
                  location: 'Ubicación',
                  latitude: 0,
                  longitude: 0,
                  imageUrls: [],
                  tags: [],
                  averageRating: 0,
                  reviewCount: 0,
                ),
              );
            },
            child: const Text('Ver todas'),
          ),
        ),
        _buildReviewItem(),
        const Divider(),
        _buildReviewItem(),
        TextButton(
          onPressed: () {},
          child: const Text('Ver todas las reseñas'),
        ),
      ],
    );
  }

  Widget _buildReviewItem() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/44.jpg',
                ),
              ),
              SizedBox(width: 8),
              Text(
                'María González',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text('4.5'),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Excelente lugar para visitar con la familia. La atención fue muy buena y las instalaciones están impecables.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class DestinationDetailsScreen extends StatefulWidget {
  final Destination destination;

  const DestinationDetailsScreen({super.key, required this.destination});

  @override
  State<DestinationDetailsScreen> createState() =>
      _DestinationDetailsScreenState();
}

class _DestinationDetailsScreenState extends State<DestinationDetailsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareDestination,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: PhotoGallery(
                imageUrls: widget.destination.imageUrls,
                onPhotoTap: (index) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => Dialog(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: InteractiveViewer(
                              panEnabled: true,
                              scaleEnabled: true,
                              child: Image.network(
                                widget.destination.imageUrls[index],
                              ),
                            ),
                          ),
                        ),
                  );
                },
              ),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.destination.location,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      custom_rating.RatingBar(
                        rating: widget.destination.averageRating,
                        reviewCount: widget.destination.reviewCount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: const [
                            Tab(text: 'Descripción'),
                            Tab(text: 'Reseñas'),
                            Tab(text: 'Ubicación'),
                          ],
                          onTap: (index) {
                            setState(() {
                              _selectedTab = index;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTabContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: // Descripción
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.destination.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (widget.destination.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.destination.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: AppColors.grey100,
                          ),
                        )
                        .toList(),
              ),
          ],
        );
      case 1: // Reseñas
        return const ReviewsPreviewSection();
      case 2: // Ubicación
        return Column(
          children: [
            MapPreview(
              location: LatLng(
                widget.destination.latitude,
                widget.destination.longitude,
              ),
              height: 200,
              markerTitle: widget.destination.name,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Dirección exacta'),
              subtitle: Text(widget.destination.location),
              onTap: _openInMaps,
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildActionButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Botón de Recomendaciones locales
            Expanded(
              flex: 3, // 60% del espacio
              child: OutlinedButton.icon(
                icon: const Icon(Icons.near_me, size: 20),
                label: const Text(
                  'Recomendaciones locales',
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Botón de Visitar
            Expanded(
              flex: 2, // 40% del espacio
              child: ElevatedButton.icon(
                icon: const Icon(Icons.flag, size: 20),
                label: const Text('Visitar', style: TextStyle(fontSize: 14)),
                onPressed: () {
                  // Agregar a un viaje
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareDestination() {
    // Implementar lógica para compartir
  }

  void _openInMaps() {
    // Implementar apertura en Google Maps
  }
}
