import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/destination.dart';
import '../theme/colors.dart';

class MapsNavigationScreen extends StatefulWidget {
  final Destination destination;
  final List<Destination>? waypoints;

  const MapsNavigationScreen({
    super.key,
    required this.destination,
    this.waypoints,
  });

  @override
  State<MapsNavigationScreen> createState() => _MapsNavigationScreenState();
}

class _MapsNavigationScreenState extends State<MapsNavigationScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _showRoute = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    final destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        widget.destination.latitude,
        widget.destination.longitude,
      ),
      infoWindow: InfoWindow(title: widget.destination.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(destinationMarker);
    });

    if (widget.waypoints != null && widget.waypoints!.isNotEmpty) {
      for (var i = 0; i < widget.waypoints!.length; i++) {
        final waypoint = widget.waypoints![i];
        final marker = Marker(
          markerId: MarkerId('waypoint_$i'),
          position: LatLng(waypoint.latitude, waypoint.longitude),
          infoWindow: InfoWindow(title: waypoint.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
        _markers.add(marker);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navegación'),
        actions: [
          IconButton(
            icon: Icon(_showRoute ? Icons.route : Icons.directions),
            onPressed: _toggleRoute,
            tooltip: _showRoute ? 'Ocultar ruta' : 'Mostrar ruta',
          ),
          IconButton(
            icon: Icon(_isNavigating ? Icons.stop : Icons.navigation),
            onPressed: _toggleNavigation,
            tooltip:
                _isNavigating ? 'Detener navegación' : 'Iniciar navegación',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.destination.latitude,
                widget.destination.longitude,
              ),
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'location_btn',
                  mini: true,
                  onPressed: _centerToUserLocation,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoom_in_btn',
                  mini: true,
                  onPressed:
                      () => _mapController.animateCamera(CameraUpdate.zoomIn()),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoom_out_btn',
                  mini: true,
                  onPressed:
                      () =>
                          _mapController.animateCamera(CameraUpdate.zoomOut()),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          if (_isNavigating)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tiempo estimado',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '25 min', // Esto debería venir de la API de direcciones
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.directions_walk, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Distancia', style: TextStyle(fontSize: 12)),
                        Text(
                          '1.2 km', // Esto debería venir de la API de direcciones
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.destination.location,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.directions),
                          onPressed: _openDirections,
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: _shareLocation,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Mostrar detalles del destino
                          },
                          child: const Text('Ver detalles'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRoute() async {
    if (!_showRoute) {
      // Simular obtención de ruta desde API de direcciones
      // En una implementación real, usarías la API de Google Maps Directions
      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        color: AppColors.primary,
        width: 5,
        points: [
          const LatLng(20.629559, -87.073885), // Punto de origen simulado
          LatLng(widget.destination.latitude, widget.destination.longitude),
        ],
      );

      setState(() {
        _polylines.add(polyline);
        _showRoute = true;
      });

      // Ajustar la cámara para mostrar toda la ruta
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          _boundsFromLatLngList(_polylines.first.points),
          100,
        ),
      );
    } else {
      setState(() {
        _polylines.clear();
        _showRoute = false;
      });
    }
  }

  void _toggleNavigation() {
    setState(() {
      _isNavigating = !_isNavigating;
    });

    if (_isNavigating && !_showRoute) {
      _toggleRoute();
    }
  }

  void _centerToUserLocation() {
    // En una implementación real, obtendrías la ubicación actual del usuario
    // Esto es solo para demostración
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(20.629559, -87.073885), // Ubicación simulada
          zoom: 16,
        ),
      ),
    );
  }

  void _openDirections() {
    // Abrir la ubicación en Google Maps u otra app de navegación
    // showDialog(...)
  }

  void _shareLocation() {
    // Compartir la ubicación a través del selector de compartir
    // showDialog(...)
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
