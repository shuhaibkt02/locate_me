import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final LatLng initialPosition;

  const MapWidget({required this.initialPosition, super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      fortyFiveDegreeImageryEnabled: true,
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 18,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: initialPosition,
          icon: BitmapDescriptor.defaultMarker,
        ),
      },
      onMapCreated: (controller) {},
    );
  }
}
