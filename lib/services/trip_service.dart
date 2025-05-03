import 'package:flutter/foundation.dart';
import '../models/destination.dart';
import '../models/trip.dart';
import 'api_service.dart';
import 'location_service.dart';

class TripService {
  final ApiService _apiService;
  final LocationService _locationService;

  TripService({
    required ApiService apiService,
    required LocationService locationService,
  }) : _apiService = apiService,
       _locationService = locationService;

  /// Obtiene los viajes del usuario
  Future<List<Trip>> getUserTrips(String userId) async {
    try {
      return await _apiService.getUserTrips(userId);
    } catch (e) {
      debugPrint('Error getting user trips: $e');
      rethrow;
    }
  }

  /// Obtiene destinos sugeridos basados en la ubicación actual
  Future<List<Destination>> getSuggestedDestinations() async {
    try {
      final position = await _locationService.getCurrentLocation();

      // Primero intenta obtener destinos cercanos
      final nearby = await _apiService.getNearbyDestinations(
        position.latitude,
        position.longitude,
        radius: 50, // 50 km de radio
      );

      // Si hay destinos cercanos, devolverlos
      if (nearby.isNotEmpty) return nearby;

      // Si no hay cercanos, devolver los populares
      return await _apiService.getPopularDestinations();
    } catch (e) {
      debugPrint('Error getting suggested destinations: $e');
      return _getFallbackDestinations();
    }
  }

  /// Crea un nuevo viaje
  Future<void> createTrip(Trip trip) async {
    try {
      await _apiService.createTrip(trip);
    } catch (e) {
      debugPrint('Error creating trip: $e');
      rethrow;
    }
  }

  /// Actualiza un viaje existente
  Future<void> updateTrip(Trip trip) async {
    try {
      await _apiService.updateTrip(trip);
    } catch (e) {
      debugPrint('Error updating trip: $e');
      rethrow;
    }
  }

  /// Elimina un viaje
  Future<void> deleteTrip(String tripId) async {
    try {
      await _apiService.deleteTrip(tripId);
    } catch (e) {
      debugPrint('Error deleting trip: $e');
      rethrow;
    }
  }

  /// Lista de destinos de fallback para cuando hay errores
  List<Destination> _getFallbackDestinations() {
    return [
      Destination(
        id: 'fallback1',
        name: 'Playa del Carmen',
        description: 'Hermosas playas de arena blanca',
        location: 'Quintana Roo, México',
        latitude: 20.629559,
        longitude: -87.073885,
        imageUrls: ['https://example.com/fallback1.jpg'],
        tags: ['playa', 'relax'],
        averageRating: 4.5,
        reviewCount: 1000,
      ),
      Destination(
        id: 'fallback2',
        name: 'Chichén Itzá',
        description: 'Maravilla del mundo maya',
        location: 'Yucatán, México',
        latitude: 20.684285,
        longitude: -88.567782,
        imageUrls: ['https://example.com/fallback2.jpg'],
        tags: ['histórico', 'cultural'],
        averageRating: 4.8,
        reviewCount: 1500,
      ),
    ];
  }

  /// Calcula el progreso de un viaje (0.0 a 1.0)
  double calculateTripProgress(Trip trip) {
    final now = DateTime.now();
    if (now.isBefore(trip.startDate)) return 0.0;
    if (now.isAfter(trip.endDate)) return 1.0;

    final totalDays = trip.endDate.difference(trip.startDate).inDays;
    final daysPassed = now.difference(trip.startDate).inDays;

    return (daysPassed / totalDays).clamp(0.0, 1.0);
  }

  /// Obtiene el estado actual del viaje
  String getTripStatus(Trip trip) {
    final now = DateTime.now();
    if (now.isBefore(trip.startDate)) return 'Planificado';
    if (now.isAfter(trip.endDate)) return 'Completado';
    return 'En progreso';
  }
}
