import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsService {
  static const String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
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

  String getStaticMapUrl(
    List<LatLng> points, {
    int width = 600,
    int height = 300,
  }) {
    final markers = points
        .map(
          (point) => 'markers=color:red%7C${point.latitude},${point.longitude}',
        )
        .join('&');
    final path =
        'path=color:0x0000ff80|weight:5|${points.map((p) => '${p.latitude},${p.longitude}').join('|')}';
    final center = LatLng(
      (points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length),
      (points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length),
    );

    return 'https://maps.googleapis.com/maps/api/staticmap?center=${center.latitude},${center.longitude}&zoom=13&size=${width}x$height&maptype=roadmap&$markers&$path&key=$apiKey';
  }
}
