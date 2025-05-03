import 'package:flutter/material.dart';
import '../widgets/destination_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/activity_indicator.dart';
import '../models/destination.dart';
import '../theme/colors.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Destination> _popularDestinations = [
    Destination(
      id: '1',
      name: 'Playa del Carmen',
      description: 'Hermosas playas de arena blanca y aguas cristalinas',
      location: 'Quintana Roo, México',
      latitude: 20.629559,
      longitude: -87.073885,
      imageUrls: [
        'https://cdn.sanity.io/images/atvntylo/production/4512065539db3fcdbc34cf03f59e90ff386d1c76-1080x720.webp?w=3840&q=65&fit=clip&auto=format',
      ],
      tags: ['Playa', 'Relax', 'Familiar'],
      averageRating: 4.7,
      reviewCount: 1245,
    ),
    Destination(
      id: '2',
      name: 'Chichén Itzá',
      description: 'Maravilla del mundo antiguo, zona arqueológica maya',
      location: 'Yucatán, México',
      latitude: 20.684285,
      longitude: -88.567782,
      imageUrls: [
        'https://escapadas.mexicodesconocido.com.mx/wp-content/uploads/2024/02/chichen-itza-pixabay.jpg',
      ],
      tags: ['Cultural', 'Histórico'],
      averageRating: 4.8,
      reviewCount: 892,
    ),
    Destination(
      id: '3',
      name: 'Barrancas del Cobre',
      description: 'Impresionante sistema de cañones en la Sierra Tarahumara',
      location: 'Chihuahua, México',
      latitude: 27.516667,
      longitude: -107.766667,
      imageUrls: [
        'https://static.wixstatic.com/media/cf3297_1207992ee7504d6b89bef1ad615630e4~mv2.jpg/v1/fill/w_568,h_378,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/cf3297_1207992ee7504d6b89bef1ad615630e4~mv2.jpg',
      ],
      tags: ['Aventura', 'Naturaleza'],
      averageRating: 4.9,
      reviewCount: 567,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViajeTotal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navegar a notificaciones
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            const CustomSearchBar(hintText: 'Buscar destinos, viajes...'),
            const SizedBox(height: 24),

            // Sección de viajes activos
            _buildActiveTripsSection(),
            const SizedBox(height: 24),

            // Destinos populares
            _buildSectionHeader(
              title: 'Destinos populares',
              onSeeAll: () {
                // Navegar a lista completa de destinos
              },
            ),
            const SizedBox(height: 12),
            _buildPopularDestinations(),
            const SizedBox(height: 24),

            // Categorías
            _buildSectionHeader(
              title: 'Explorar por categoría',
              onSeeAll: null,
            ),
            const SizedBox(height: 12),
            _buildCategoriesGrid(),
            const SizedBox(height: 24),

            // Recomendaciones personalizadas
            _buildSectionHeader(
              title: 'Recomendaciones para ti',
              onSeeAll: () {
                // Navegar a recomendaciones personalizadas
              },
            ),
            const SizedBox(height: 12),
            _buildPersonalizedRecommendations(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildActiveTripsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.travelLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              ActivityIndicator(
                isActive: true,
                activeText: 'Viaje en progreso: Cancún',
              ),
              Spacer(),
              Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: AppColors.grey200,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('3 de 5 días completados', style: TextStyle(fontSize: 12)),
              Text(
                '60% completado',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('Ver todos')),
      ],
    );
  }

  Widget _buildPopularDestinations() {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ), // Add horizontal padding
        itemCount: _popularDestinations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: DestinationCard(
              destination: _popularDestinations[index],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/destination',
                  arguments: _popularDestinations[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    const categories = [
      {
        'icon': Icons.beach_access,
        'name': 'Playas',
        'color': AppColors.leisure,
      },
      {
        'icon': Icons.landscape,
        'name': 'Naturaleza',
        'color': AppColors.success,
      },
      {
        'icon': Icons.account_balance,
        'name': 'Cultural',
        'color': AppColors.secondary,
      },
      {'icon': Icons.hiking, 'name': 'Aventura', 'color': AppColors.adventure},
      {
        'icon': Icons.family_restroom,
        'name': 'Familiar',
        'color': AppColors.primaryLight,
      },
      {
        'icon': Icons.fastfood,
        'name': 'Gastronomía',
        'color': AppColors.secondaryDark,
      },
    ];

    return SizedBox(
      height: 220, // Fixed height to prevent overflow
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 8, // Reduced spacing
        mainAxisSpacing: 8, // Reduced spacing
        childAspectRatio: 1.2, // Adjusted aspect ratio
        children:
            categories.map((category) {
              return Card(
                margin: const EdgeInsets.all(4), // Added margin
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Filtrar por categoría
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8), // Reduced padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10), // Reduced padding
                          decoration: BoxDecoration(
                            color: (category['color'] as Color).withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 24, // Reduced icon size
                          ),
                        ),
                        const SizedBox(height: 6), // Reduced spacing
                        Text(
                          category['name'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11, // Reduced font size
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPersonalizedRecommendations() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16), // Added padding
        children:
            [
                  _buildRecommendationCard(
                    title: 'Ofertas especiales',
                    subtitle: 'Descuentos hasta 40%',
                    imageUrl:
                        'https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082_1280.jpg',
                  ),
                  _buildRecommendationCard(
                    title: 'Lugares cercanos',
                    subtitle: 'Descubre tu alrededor',
                    imageUrl:
                        'https://cdn.pixabay.com/photo/2015/07/29/22/56/taj-mahal-866692_1280.jpg',
                  ),
                  _buildRecommendationCard(
                    title: 'Temporada baja',
                    subtitle: 'Viaja con menos gente',
                    imageUrl:
                        'https://cdn.pixabay.com/photo/2017/12/15/13/51/polynesia-3021072_1280.jpg',
                  ),
                ]
                .map(
                  (card) => SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.8, // Responsive width
                    child: card,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(77),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0, // Home seleccionado
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey600,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explorar'),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket),
          label: 'Viajes',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(), // ← debe ser un Widget
            ),
          );
        }
        // Puedes agregar navegación a las demás pantallas si las tienes
      },
    );
  }
}
