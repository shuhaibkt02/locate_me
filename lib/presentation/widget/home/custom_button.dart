import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/logic/location_provider.dart';
import 'package:locate_me/presentation/screen/detail_screen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.initialLocationAsyncValue,
    required this.width,
    required this.textTheme,
  });

  final AsyncValue<MapLocation> initialLocationAsyncValue;
  final double width;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 12),
      child: InkWell(
        onTap: () {
          initialLocationAsyncValue.when(
            data: (initialLocation) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    address: initialLocation.address,
                    position: initialLocation.position,
                  ),
                )),
            loading: () {},
            error: (error, stackTrace) => const Text('Error'),
          );
        },
        child: Container(
          height: 55,
          width: width / 1.5,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey, width: 0.1),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade900,
                  offset: const Offset(0, 20),
                  blurRadius: 100,
                  spreadRadius: 1,
                )
              ]),
          child: Center(
            child: Text(
              'Continue',
              style: textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
