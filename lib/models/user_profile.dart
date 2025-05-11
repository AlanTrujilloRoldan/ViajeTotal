class UserProfile {
  final String name;
  final String email;
  final DateTime memberSince;
  final String photoUrl;
  final int tripsCompleted;
  final int countriesVisited;
  final String favoriteDestination;

  UserProfile({
    required this.name,
    required this.email,
    required this.memberSince,
    required this.photoUrl,
    required this.tripsCompleted,
    required this.countriesVisited,
    required this.favoriteDestination,
  });
}