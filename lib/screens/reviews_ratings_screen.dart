import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/destination.dart';
import '../theme/colors.dart';

class ReviewsRatingsScreen extends StatefulWidget {
  final Destination destination;

  const ReviewsRatingsScreen({super.key, required this.destination});

  @override
  State<ReviewsRatingsScreen> createState() => _ReviewsRatingsScreenState();
}

class _ReviewsRatingsScreenState extends State<ReviewsRatingsScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reseñas de ${widget.destination.name}')),
      body: Column(
        children: [
          // Resumen de ratings
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.grey100,
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.destination.averageRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: widget.destination.averageRating,
                      itemBuilder:
                          (context, index) => const Icon(
                            Icons.star,
                            color: AppColors.secondary,
                          ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                    Text(
                      '${widget.destination.reviewCount} reseñas',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingProgress(5, 0.75),
                      _buildRatingProgress(4, 0.15),
                      _buildRatingProgress(3, 0.05),
                      _buildRatingProgress(2, 0.03),
                      _buildRatingProgress(1, 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de reseñas
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Número simulado de reseñas
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _buildReviewItem();
              },
            ),
          ),

          // Formulario para nueva reseña
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: const Border(top: BorderSide(color: AppColors.grey300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agrega tu reseña',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: _userRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star, color: AppColors.secondary),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _userRating = rating;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Comparte tu experiencia...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Enviar reseña'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingProgress(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$stars estrellas', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.grey300,
              color: AppColors.secondary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).round()}%',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/11/verticalimage1669078554123-2877435.jpg?tf=1200x1200',
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuario Ejemplo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text('4.5'),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              'Hace 2 semanas',
              style: TextStyle(fontSize: 12, color: AppColors.grey600),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Excelente lugar para visitar con la familia. La atención fue muy buena y las instalaciones están impecables.',
        ),
        SizedBox(height: 8),
        // Fotos de la reseña podrían ir aquí
      ],
    );
  }

  void _submitReview() {
    if (_userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una calificación')),
      );
      return;
    }

    // Enviar la reseña al backend
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Reseña enviada con éxito')));

    // Limpiar el formulario
    setState(() {
      _userRating = 0;
      _reviewController.clear();
    });
  }
}

class ReviewsPreviewSection extends StatelessWidget {
  const ReviewsPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Reseñas recientes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: TextButton(
            onPressed: () {
              // Navegar a pantalla completa de reseñas
            },
            child: const Text('Ver todas'),
          ),
        ),
        // Mostrar 2-3 reseñas de ejemplo
        _buildReviewItem(),
        const Divider(),
        _buildReviewItem(),
        TextButton(
          onPressed: () {
            // Navegar a pantalla completa de reseñas
          },
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
                  'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/11/verticalimage1669078554123-2877435.jpg?tf=1200x1200',
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Usuario Ejemplo',
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
            'Muy buen lugar, volvería sin duda...',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
