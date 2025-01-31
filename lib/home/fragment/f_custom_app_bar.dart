import 'package:chool_check/common/provider/map_controller_provider.dart';
import 'package:chool_check/home/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FCustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const FCustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void onLocationButtonPressed(WidgetRef ref) async {
    final controller = ref.read(mapControllerProvider);
    final state = ref.read(locationProvider);

    if (controller != null && state.position != null) {
      controller.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            state.position!.latitude,
            state.position!.longitude,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.5),
      title: const Text(
        '출근 출석하기!',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          color: Colors.blue,
          onPressed: () => onLocationButtonPressed(ref),
          icon: const Icon(Icons.my_location),
        ),
      ],
    );
  }
}
