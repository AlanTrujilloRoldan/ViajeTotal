import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/journal_entry.dart';

class JournalService {
  // Cargar todas las entradas del JSON
  Future<List<JournalEntry>> getJournalEntries(String tripId) async {
    final String response = await rootBundle.loadString(
      'assets/data/journals.json',
    );
    final Map<String, dynamic> data = json.decode(response);

    if (data['tripId'] == tripId) {
      return [JournalEntry.fromMap(data)];
    }
    return [];
  }

  Future<void> createJournalEntry(JournalEntry entry) async {
    // En una app real, aquí se enviaría a una API o se guardaría localmente
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Actualizar una entrada existente
  Future<void> updateJournalEntry(JournalEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Eliminar una entrada
  Future<void> deleteJournalEntry(String entryId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
