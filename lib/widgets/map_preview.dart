import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPreview extends StatelessWidget {
  final LatLng location;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final String? markerTitle;

  const MapPreview({
    super.key,
    required this.location,
    this.height,
    this.width,
    this.onTap,
    this.markerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 150,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: location,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('preview_location'),
                    position: location,
                    infoWindow:
                        markerTitle != null
                            ? InfoWindow(title: markerTitle!)
                            : const InfoWindow(title: ''),
                  ),
                },
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
                zoomGesturesEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
              ),
              if (onTap != null)
                const Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.zoom_in_map,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
