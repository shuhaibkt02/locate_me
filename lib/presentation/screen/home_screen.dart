import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/logic/location_provider.dart';
import 'package:locate_me/presentation/widget/home/alert_box.dart';
import 'package:locate_me/presentation/widget/home/custom_button.dart';
import 'package:locate_me/presentation/widget/home/map_widget.dart';

final locationProvider = FutureProvider.autoDispose<MapLocation>((ref) async {
  return await LocationService().getCurrentLocation();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialLocationAsyncValue = ref.watch(locationProvider);
    final textTheme = Theme.of(context).textTheme;
    double width = MediaQuery.sizeOf(context).width;

    PreferredSizeWidget appBar() {
      return AppBar(
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
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop == false) {
          await showDialog(
            context: context,
            builder: (context) => const AlertBox(),
          );
        }
      },
      child: Scaffold(
        appBar: appBar(),
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
        floatingActionButton: CustomButton(
          initialLocationAsyncValue: initialLocationAsyncValue,
          width: width,
          textTheme: textTheme,
        ),
      ),
    );
  }
}
