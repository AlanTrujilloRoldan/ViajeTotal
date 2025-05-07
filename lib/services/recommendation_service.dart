import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/recommendation.dart';

class RecommendationService {
  Future<List<Recommendation>> getRecommendationServices() async {
    final String response = await rootBundle.loadString(
      'assets/data/recommendations.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((item) => Recommendation.fromMap(item)).toList();
  }

  Future<Recommendation?> getRecommendationById(String id) async {
    final recommendations = await getRecommendationServices();
    try {
      return recommendations.firstWhere((rec) => rec.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Recommendation?> getRecommendationByDestinationId(String destinationId) async {
    final recommendations = await getRecommendationServices();
    try {
      return recommendations.firstWhere((rec) => rec.destinationId == destinationId);
    } catch (e) {
      return null;
    }
  }
}