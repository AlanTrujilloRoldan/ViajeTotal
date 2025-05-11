import 'package:flutter/material.dart';
import '../services/destination_service.dart';
import '../services/trip_service.dart';
import '../widgets/destination_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/activity_indicator.dart';
import '../models/destination.dart';
import '../models/trip.dart';
import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DestinationService _destinationService = DestinationService();
  late Future<List<Destination>> _destinationsFuture;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    _destinationsFuture = _destinationService.getPopularDestinations();
  }

  void _navigateToSearchWithCategory(String category) {
    Navigator.pushNamed(context, '/search', arguments: {'category': category});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ViajeTotal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(
              hintText: 'Buscar destinos, viajes...',
              onTap: () => Navigator.pushNamed(context, '/search'),
            ),
            const SizedBox(height: 24),
            _buildActiveTripsSection(),
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: 'Destinos populares',
              onSeeAll: () => Navigator.pushNamed(context, '/search'),
            ),
            const SizedBox(height: 14),
            FutureBuilder<List<Destination>>(
              future: _destinationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay destinos disponibles');
                }
                return _buildPopularDestinations(snapshot.data!);
              },
            ),
            const SizedBox(height: 25),
            _buildSectionHeader(
              title: 'Explorar por categoría',
              onSeeAll: null,
            ),
            const SizedBox(height: 12),
            _buildCategoriesGrid(),
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: 'Recomendaciones para ti',
              onSeeAll: () {},
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
    final tripService = TripService();

    return FutureBuilder<List<Trip>>(
      future: tripService.getUserTrips(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.travelLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Error al cargar los viajes'),
          );
        }

        final trips = snapshot.data ?? [];
        final activeTrips =
            trips.where((trip) {
              final status = tripService.getTripStatus(trip);
              return status == 'En progreso';
            }).toList();

        if (activeTrips.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.travelLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('No tienes viajes en progreso'),
          );
        }

        final currentTrip = activeTrips.first;
        final progress = tripService.calculateTripProgress(currentTrip);
        final totalDays =
            currentTrip.endDate.difference(currentTrip.startDate).inDays;
        final daysPassed =
            DateTime.now().difference(currentTrip.startDate).inDays;

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/journal', // Asegúrate de tener esta ruta configurada
              arguments: currentTrip, // Pasamos el objeto Trip completo
            );
          },
          child: Container(
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
                Row(
                  children: [
                    ActivityIndicator(
                      isActive: true,
                      activeText: 'Viaje en progreso: ${currentTrip.title}',
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.grey200,
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$daysPassed de $totalDays días completados',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% completado',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildPopularDestinations(List<Destination> destinations) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: destinations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: DestinationCard(
              destination: destinations[index],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/destination',
                  arguments: destinations[index],
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
        'tag': 'Playa',
      },
      {
        'icon': Icons.landscape,
        'name': 'Naturaleza',
        'color': AppColors.success,
        'tag': 'Naturaleza',
      },
      {
        'icon': Icons.account_balance,
        'name': 'Cultural',
        'color': AppColors.secondary,
        'tag': 'Cultural',
      },
      {
        'icon': Icons.hiking,
        'name': 'Aventura',
        'color': AppColors.adventure,
        'tag': 'Aventura',
      },
      {
        'icon': Icons.family_restroom,
        'name': 'Familiar',
        'color': AppColors.primaryLight,
        'tag': 'Familiar',
      },
      {
        'icon': Icons.fastfood,
        'name': 'Gastronomía',
        'color': AppColors.secondaryDark,
        'tag': 'Gastronomía',
      },
    ];

    return SizedBox(
      height: 220,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
        children:
            categories.map((category) {
              return Card(
                margin: const EdgeInsets.all(4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap:
                      () => _navigateToSearchWithCategory(
                        category['tag'] as String,
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (category['color'] as Color).withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category['name'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    width: MediaQuery.of(context).size.width * 0.8,
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
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey600,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.hiking), label: 'Destinos'),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket),
          label: 'Mis Viajes',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/search');
            break;
          case 2:
            Navigator.pushNamed(context, '/trips');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
