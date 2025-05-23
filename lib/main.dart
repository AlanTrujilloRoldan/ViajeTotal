import 'package:flutter/material.dart';
import 'package:viajetotal/screens/home_screen.dart';
import 'package:viajetotal/screens/destination_details_screen.dart';
import 'package:viajetotal/screens/trip_planning_screen.dart';
import 'package:viajetotal/screens/journal_screen.dart';
import 'package:viajetotal/screens/maps_navigation_screen.dart';
import 'package:viajetotal/screens/destination_screen.dart';
import 'package:viajetotal/screens/trips_screen.dart';
import 'package:viajetotal/screens/reviews_ratings_screen.dart';
import 'package:viajetotal/screens/local_recommendations_screen.dart';
import 'package:viajetotal/screens/journal_new_screen.dart';
import 'package:viajetotal/screens/journal_edit_screen.dart';
import 'package:viajetotal/screens/profile_screen.dart';
import 'package:viajetotal/theme/app_theme.dart';
import 'package:viajetotal/models/destination.dart';
import 'package:viajetotal/models/trip.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const ViajeTotalApp());
  });
}

class ViajeTotalApp extends StatelessWidget {
  const ViajeTotalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViajeTotal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/trips': (context) => const TripsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/destination': (context) {
          final destination =
              ModalRoute.of(context)!.settings.arguments as Destination;
          return DestinationDetailsScreen(destination: destination);
        },
        '/plan-trip': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return TripPlanningScreen(
            initialDestination: args is Destination ? args : null,
          );
        },
        '/journal': (context) {
          final trip = ModalRoute.of(context)!.settings.arguments as Trip;
          return TravelJournalScreen(trip: trip);
        },
        '/journal_new': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return JournalEntryNewScreen(
            tripId: args['tripId'],
            onSave: args['onSave'],
          );
        },
        '/journal_edit': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return JournalEntryEditScreen(
            entry: args['entry'],
            onUpdate: args['onUpdate'],
            onDelete: args['onDelete'],
          );
        },
        '/navigation': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return MapsNavigationScreen(
            destination: args['destination'] as Destination,
            waypoints: args['waypoints'] as List<Destination>?,
          );
        },
        '/reviews': (context) {
          final destination =
              ModalRoute.of(context)!.settings.arguments as Destination;
          return ReviewsRatingsScreen(destination: destination);
        },
        '/local-recommendations': (context) {
          final destinationId =
              ModalRoute.of(context)!.settings.arguments as String;
          return LocalRecommendationsScreen(destinationId: destinationId);
        },
      },
      onGenerateRoute: (settings) {
        // Manejar rutas no definidas
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: Center(
                  child: Text('No se encontró la ruta ${settings.name}'),
                ),
              ),
        );
      },
    );
  }
}
