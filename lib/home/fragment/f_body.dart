import 'package:chool_check/home/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FBody extends ConsumerWidget {
  const FBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapNotifier = ref.read(mapProvider.notifier);
    final MapState mapState = ref.watch(mapProvider);

    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: mapNotifier.onMapCreated,
      initialCameraPosition: mapState.initialPosition,
      markers: mapState.markers,
      circles: mapState.circles,
    );
  }
}
