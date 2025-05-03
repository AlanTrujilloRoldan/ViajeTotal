class Recommendation {
  final String id;
  final String destinationId;
  final String title;
  final String description;
  final String category;
  final String address;
  final double? price;
  final double rating;
  final List<String> imageUrls;
  final String? websiteUrl;
  final String? phoneNumber;

  Recommendation({
    required this.id,
    required this.destinationId,
    required this.title,
    required this.description,
    required this.category,
    required this.address,
    this.price,
    required this.rating,
    required this.imageUrls,
    this.websiteUrl,
    this.phoneNumber,
  });

  factory Recommendation.fromMap(Map<String, dynamic> map) {
    return Recommendation(
      id: map['id'],
      destinationId: map['destinationId'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      address: map['address'],
      price: map['price']?.toDouble(),
      rating: map['rating']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(map['imageUrls']),
      websiteUrl: map['websiteUrl'],
      phoneNumber: map['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destinationId': destinationId,
      'title': title,
      'description': description,
      'category': category,
      'address': address,
      'price': price,
      'rating': rating,
      'imageUrls': imageUrls,
      'websiteUrl': websiteUrl,
      'phoneNumber': phoneNumber,
    };
  }
}
