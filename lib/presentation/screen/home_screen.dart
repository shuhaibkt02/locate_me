import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/logic/location_provider.dart';
import 'package:locate_me/presentation/screen/detail_screen.dart';

final locationProvider = FutureProvider.autoDispose<MapLocation>((ref) async {
  return await LocationService().getCurrentLocation();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialLocationAsyncValue = ref.watch(locationProvider);
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop == false) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit '),
              content: const Text('Are you sure you want to leave?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarOpacity: 0.1,
          backgroundColor: Colors.grey.shade300,
          title: initialLocationAsyncValue.when(
            data: (initialLocation) => Text(
              initialLocation.address,
              style: textTheme.bodyLarge,
            ),
            loading: () => const Text('Loading...'),
            error: (error, stackTrace) => const Text('Error'),
          ),
        ),
        body: initialLocationAsyncValue.when(
          data: (initialLocation) {
            return MapWidget(initialPosition: initialLocation.position);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          ),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              initialLocationAsyncValue.when(
                data: (initialLocation) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(initialLocation.address),
                    )),
                loading: () {},
                error: (error, stackTrace) => const Text('Error'),
              );
            },
            label: const Icon(Icons.golf_course_rounded),
          ),
        ),
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  final LatLng initialPosition;

  const MapWidget({required this.initialPosition, super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.satellite,
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
