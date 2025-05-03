class JournalEntry {
  final String id;
  final String tripId;
  final DateTime date;
  final String title;
  final String content;
  final List<String> imageUrls;
  final String location;
  final double? latitude;
  final double? longitude;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.tripId,
    required this.date,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.location,
    this.latitude,
    this.longitude,
    required this.tags,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      tripId: map['tripId'],
      date: DateTime.parse(map['date']),
      title: map['title'],
      content: map['content'],
      imageUrls: List<String>.from(map['imageUrls']),
      location: map['location'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      tags: List<String>.from(map['tags']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
    };
  }
}
