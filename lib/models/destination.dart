class Destination {
  final String id;
  final String name;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final List<String> tags;
  final double averageRating;
  final int reviewCount;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.tags,
    required this.averageRating,
    required this.reviewCount,
  });

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      location: map['location'],
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(map['imageUrls']),
      tags: List<String>.from(map['tags']),
      averageRating: map['averageRating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrls': imageUrls,
      'tags': tags,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }
}
