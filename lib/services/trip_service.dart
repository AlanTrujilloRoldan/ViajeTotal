import 'package:flutter/services.dart'; // Para rootBundle
import 'dart:convert';
import '../models/trip.dart';

class TripService {
  Future<List<Trip>> getUserTrips() async {
    try {
      // Cargar el archivo JSON desde assets
      final String response = await rootBundle.loadString(
        'assets/data/trips.json',
      );
      final List<dynamic> data = json.decode(response);

      // Convertir cada objeto JSON en un objeto Trip
      return data.map((item) => Trip.fromMap(item)).toList();
    } catch (e) {
      rethrow; // O devolver una lista vacía si prefieres manejar el error silenciosamente
    }
  }

  // Métodos adicionales (opcional)
  Future<void> createTrip(Trip trip) async {
    // Lógica para guardar el viaje (si es necesario)
  }

  double calculateTripProgress(Trip trip) {
    final now = DateTime.now();
    if (now.isBefore(trip.startDate)) return 0.0;
    if (now.isAfter(trip.endDate)) return 1.0;

    final totalDays = trip.endDate.difference(trip.startDate).inDays;
    final daysPassed = now.difference(trip.startDate).inDays;

    return (daysPassed / totalDays).clamp(0.0, 1.0);
  }

  String getTripStatus(Trip trip) {
    final now = DateTime.now();
    if (now.isBefore(trip.startDate)) return 'Planificado';
    if (now.isAfter(trip.endDate)) return 'Completado';
    return 'En progreso';
  }
}
