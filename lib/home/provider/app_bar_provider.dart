import 'package:chool_check/common/provider/map_controller_provider.dart';
import 'package:chool_check/home/provider/location_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final appBarProvider = StateNotifierProvider<AppBarNotifier, void>((ref) {
  return AppBarNotifier(ref);
});

class AppBarNotifier extends StateNotifier<void> {
  final Ref ref;

  AppBarNotifier(this.ref) : super(null);

  Future<void> moveToCurrentLocation() async {
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
}
