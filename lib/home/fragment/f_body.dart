import 'package:chool_check/home/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FBody extends ConsumerWidget {
  const FBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final mapNotifier = ref.read(mapProvider.notifier);

    return GoogleMap(
      onMapCreated: mapNotifier.onMapCreated,
      initialCameraPosition: mapState.initialPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: mapState.markers,
      circles: mapState.circles,
    );
  }
}
