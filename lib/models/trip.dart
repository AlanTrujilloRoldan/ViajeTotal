class Trip {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final List<String> destinationIds;
  final List<String> participantIds;
  final String coverImageUrl;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.destinationIds,
    required this.participantIds,
    required this.coverImageUrl,
  });

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      budget: map['budget']?.toDouble() ?? 0.0,
      destinationIds: List<String>.from(map['destinationIds']),
      participantIds: List<String>.from(map['participantIds']),
      coverImageUrl: map['coverImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'budget': budget,
      'destinationIds': destinationIds,
      'participantIds': participantIds,
      'coverImageUrl': coverImageUrl,
    };
  }
}
