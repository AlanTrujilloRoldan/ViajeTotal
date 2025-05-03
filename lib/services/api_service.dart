import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';
import '../models/trip.dart';

class ApiService {
  final String baseUrl;
  final String apiKey;

  ApiService({required this.baseUrl, required this.apiKey});

  Future<List<Trip>> getUserTrips(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/trips?userId=$userId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Trip.fromMap(item)).toList();
    }
    throw Exception('Failed to load trips');
  }

  Future<List<Destination>> getPopularDestinations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/destinations/popular'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Destination.fromMap(item)).toList();
    }
    throw Exception('Failed to load popular destinations');
  }

  Future<List<Destination>> getNearbyDestinations(
    double latitude,
    double longitude, {
    double radius = 50,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/destinations/nearby?lat=$latitude&lng=$longitude&radius=$radius',
      ),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Destination.fromMap(item)).toList();
    }
    return []; // Retorna lista vacía si falla
  }

  Future<void> createTrip(Trip trip) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trips'),
      headers: _getHeaders(),
      body: json.encode(trip.toMap()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create trip');
    }
  }

  Future<void> updateTrip(Trip trip) async {
    final response = await http.put(
      Uri.parse('$baseUrl/trips/${trip.id}'),
      headers: _getHeaders(),
      body: json.encode(trip.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update trip');
    }
  }

  Future<void> deleteTrip(String tripId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/trips/$tripId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete trip');
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }
}
