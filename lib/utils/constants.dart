class AppConstants {
  // Constantes generales de la aplicación
  static const String appName = 'ViajeTotal';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'TuNombre';
  static const String appSupportEmail = 'soporte@viajetotal.com';

  // Rutas de API
  static const String apiBaseUrl = 'https://api.viajetotal.com/v1';
  static const String tripsEndpoint = '/trips';
  static const String destinationsEndpoint = '/destinations';
  static const String recommendationsEndpoint = '/recommendations';
  static const String journalEndpoint = '/journal';
  static const String usersEndpoint = '/users';

  // Claves de almacenamiento local
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String firstLaunchKey = 'first_launch';
  static const String darkModeKey = 'dark_mode';

  // Límites y defaults
  static const int maxDestinationsPerTrip = 10;
  static const int maxTripDays = 30;
  static const int maxJournalPhotos = 10;
  static const double defaultBudget = 1000.00;
  static const int defaultTripDuration = 7;

  // Textos constantes
  static const String defaultErrorMessage = 'Ocurrió un error inesperado';
  static const String noInternetMessage = 'No hay conexión a Internet';
  static const String emptyListMessage = 'No hay elementos para mostrar';
  static const String tryAgainMessage = 'Intentar nuevamente';

  // Assets paths
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.jpg';
  static const String emptyStatePath = 'assets/images/empty_state.svg';
  static const String errorStatePath = 'assets/images/error_state.svg';

  // Tiempos y delays
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration apiTimeout = Duration(seconds: 15);
  static const Duration debounceTime = Duration(milliseconds: 500);
}

class TripCategories {
  static const List<String> all = [
    'Aventura',
    'Playa',
    'Ciudad',
    'Montaña',
    'Cultural',
    'Gastronómico',
    'Romántico',
    'Familiar',
    'Negocios',
    'Road Trip',
  ];
}

class RecommendationTypes {
  static const List<String> all = [
    'Restaurante',
    'Hotel',
    'Atracción',
    'Transporte',
    'Evento',
    'Tienda',
    'Emergencia',
    'Información',
  ];
}
