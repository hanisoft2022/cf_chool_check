import 'package:chool_check/common/const/markers.dart';
import 'package:chool_check/common/provider/map_controller_provider.dart';
import 'package:chool_check/home/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final CameraPosition initialPosition;
  final Set<Circle> circles;
  final Set<Marker> markers;

  MapState({
    this.initialPosition = const CameraPosition(target: LatLng(37.51824327980506, 126.80642272189212), zoom: 15),
    this.circles = const {},
    this.markers = const {},
  });

  MapState copyWith({
    CameraPosition? initialPosition,
    Set<Circle>? circles,
    Set<Marker>? markers,
  }) {
    return MapState(
      initialPosition: initialPosition ?? this.initialPosition,
      circles: circles ?? this.circles,
      markers: markers ?? this.markers,
    );
  }
}

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) => MapNotifier(ref));

class MapNotifier extends StateNotifier<MapState> {
  final Ref ref;

  MapNotifier(this.ref) : super(MapState()) {
    _initializeMap();
  }

  void _initializeMap() {
    final locationState = ref.read(locationProvider);

    final circles = {
      Circle(
        circleId: const CircleId('원종초 출근 인정 범위'),
        center: markers['원종초등학교']!.position,
        radius: 100,
        strokeWidth: 1,
        fillColor: locationState.canChoolCheck ? Colors.blue.withAlpha(128) : Colors.red.withAlpha(128),
        strokeColor: locationState.canChoolCheck ? Colors.blue.withAlpha(128) : Colors.red.withAlpha(128),
      ),
    };

    state = state.copyWith(markers: {markers['원종초등학교']!}, circles: circles);
  }

  void onMapCreated(GoogleMapController controller) {
    ref.read(mapControllerProvider.notifier).state = controller;
  }
}
