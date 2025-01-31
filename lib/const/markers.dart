import 'package:google_maps_flutter/google_maps_flutter.dart';

Map<String, Marker> markers = {'원종초등학교': mWonjong};

const mWonjong = Marker(
  markerId: MarkerId('원종초등학교'),
  position: LatLng(37.51824327980506, 126.80642272189212),
);
