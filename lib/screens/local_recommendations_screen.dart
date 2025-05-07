import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/rating_bar.dart';
import '../models/recommendation.dart';
import '../services/recommendation_service.dart';
import '../theme/colors.dart';

class LocalRecommendationsScreen extends StatefulWidget {
  final String destinationId;

  const LocalRecommendationsScreen({super.key, required this.destinationId});

  @override
  State<LocalRecommendationsScreen> createState() =>
      _LocalRecommendationsScreenState();
}

class _LocalRecommendationsScreenState extends State<LocalRecommendationsScreen> {
  String _selectedCategory = 'Todos';
  late Future<List<Recommendation>> _recommendationsFuture;
  final RecommendationService _recommendationService = RecommendationService();

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = _loadRecommendations();
  }

  Future<List<Recommendation>> _loadRecommendations() async {
    final allRecommendations = await _recommendationService.getRecommendationServices();
    return allRecommendations.where((r) => r.destinationId == widget.destinationId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendaciones locales'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Recommendation>>(
        future: _recommendationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay recomendaciones disponibles'));
          }

          final recommendations = snapshot.data!;
          final filteredRecommendations = _selectedCategory == 'Todos'
              ? recommendations
              : recommendations.where((r) => r.category == _selectedCategory).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomSearchBar(
                  hintText: 'Buscar recomendaciones...',
                  onChanged: (query) {
                    // Implementar búsqueda
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip('Todos'),
                    _buildCategoryChip('Restaurante'),
                    _buildCategoryChip('Hotel'),
                    _buildCategoryChip('Atracción'),
                    _buildCategoryChip('Transporte'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredRecommendations.length,
                  itemBuilder: (context, index) {
                    final recommendation = filteredRecommendations[index];
                    return _buildRecommendationCard(recommendation);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.grey700,
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(Recommendation recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showRecommendationDetails(recommendation);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: AppColors.grey200,
                      child: recommendation.imageUrls.isNotEmpty
                          ? Image.network(
                              recommendation.imageUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image),
                            )
                          : const Icon(Icons.image),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Información
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recommendation.category,
                          style: TextStyle(
                            color: AppColors.grey600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.grey600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                recommendation.address,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBar(rating: recommendation.rating, size: 16),
                            const Spacer(),
                            if (recommendation.price != null)
                              Text(
                                '\$${recommendation.price!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecommendationDetails(Recommendation recommendation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.grey400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                recommendation.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      recommendation.category,
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  RatingBar(rating: recommendation.rating, showCount: false),
                ],
              ),
              const SizedBox(height: 16),
              // Galería de imágenes
              if (recommendation.imageUrls.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendation.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < recommendation.imageUrls.length - 1 ? 8 : 0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recommendation.imageUrls[index],
                            width: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              // Información detallada
              const Text(
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(recommendation.description),
              const SizedBox(height: 16),
              // Información de contacto
              const Text(
                'Información de contacto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (recommendation.address.isNotEmpty)
                _buildDetailItem(
                  icon: Icons.location_on_outlined,
                  text: recommendation.address,
                ),
              if (recommendation.phoneNumber != null)
                _buildDetailItem(
                  icon: Icons.phone,
                  text: recommendation.phoneNumber!,
                  isAction: true,
                  onTap: () {
                    // Llamar al número
                  },
                ),
              if (recommendation.websiteUrl != null)
                _buildDetailItem(
                  icon: Icons.language,
                  text: recommendation.websiteUrl!,
                  isAction: true,
                  onTap: () {
                    // Abrir sitio web
                  },
                ),
              const SizedBox(height: 24),
              // Botón de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Agregar a mi itinerario
                  },
                  child: const Text('Agregar a mi viaje'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String text,
    bool isAction = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isAction ? onTap : null,
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.grey600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isAction ? AppColors.primary : null,
                  decoration:
                      isAction ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}