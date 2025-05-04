import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/destination.dart';

class DestinationService {
  Future<List<Destination>> getPopularDestinations() async {
    final String response = await rootBundle.loadString(
      'assets/data/destinations.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((item) => Destination.fromMap(item)).toList();
  }

  Future<Destination?> getDestinationById(String id) async {
    final destinations = await getPopularDestinations();
    try {
      return destinations.firstWhere((dest) => dest.id == id);
    } catch (e) {
      return null;
    }
  }
}
