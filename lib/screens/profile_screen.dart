import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../widgets/stats_card.dart';
import '../widgets/settings_option.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Simular carga de datos
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _userProfile = UserProfile(
        name: 'Ana Martínez',
        email: 'ana@example.com',
        memberSince: DateTime(2023, 1, 15),
        photoUrl: 'https://example.com/profile.jpg',
        tripsCompleted: 12,
        countriesVisited: 8,
        favoriteDestination: 'París',
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navegar a pantalla de edición de perfil
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildSettingsSection(),
                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(_userProfile.photoUrl),
          onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 50),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userProfile.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              _userProfile.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Miembro desde ${_userProfile.memberSince.year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis Estadísticas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            StatsCard(
              icon: Icons.airplanemode_active,
              value: _userProfile.tripsCompleted.toString(),
              label: 'Viajes realizados',
            ),
            StatsCard(
              icon: Icons.flag,
              value: _userProfile.countriesVisited.toString(),
              label: 'Países visitados',
            ),
            StatsCard(
              icon: Icons.favorite,
              value: _userProfile.favoriteDestination,
              label: 'Destino favorito',
            ),
            StatsCard(
              icon: Icons.calendar_today,
              value: '${DateTime.now().year - _userProfile.memberSince.year}',
              label: 'Años viajando',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuración',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              SettingsOption(
                icon: Icons.notifications,
                title: 'Notificaciones',
                onTap: () {
                  // Navegar a configuración de notificaciones
                },
              ),
              const Divider(height: 1),
              SettingsOption(
                icon: Icons.security,
                title: 'Privacidad',
                onTap: () {
                  // Navegar a configuración de privacidad
                },
              ),
              const Divider(height: 1),
              SettingsOption(
                icon: Icons.help,
                title: 'Ayuda y soporte',
                onTap: () {
                  // Navegar a ayuda
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          _showLogoutConfirmation();
        },
        child: const Text('Cerrar sesión'),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Lógica para cerrar sesión
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}