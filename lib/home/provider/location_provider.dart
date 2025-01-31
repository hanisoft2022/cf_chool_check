import 'package:chool_check/common/const/markers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState {
  final Position? position;
  final bool canChoolCheck;
  final bool choolCheckDone;

  LocationState({
    this.position,
    this.canChoolCheck = false,
    this.choolCheckDone = false,
  });

  LocationState copyWith({
    Position? position,
    bool? canChoolCheck,
    bool? choolCheckDone,
  }) {
    return LocationState(
      position: position ?? this.position,
      canChoolCheck: canChoolCheck ?? this.canChoolCheck,
      choolCheckDone: choolCheckDone ?? this.choolCheckDone,
    );
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(),
);

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  Future<void> determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw '위치 기능을 활성화해주세요.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw '위치 권한을 허용해주세요.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw '위치 권한이 거절되었습니다. \n\'설정\'앱에서 위치 권한을 허용해주세요.';
      }

      final position = await Geolocator.getCurrentPosition();
      state = state.copyWith(position: position);

      // 위치 스트림 시작
      startLocationStream();
    } catch (e) {
      rethrow;
    }
  }

  void startLocationStream() {
    Geolocator.getPositionStream().listen((event) {
      final officeCenterLatLng = markers['원종초등학교']!.position;
      final currentLatLng = LatLng(event.latitude, event.longitude);

      final distance = Geolocator.distanceBetween(
        officeCenterLatLng.latitude,
        officeCenterLatLng.longitude,
        currentLatLng.latitude,
        currentLatLng.longitude,
      );

      state = state.copyWith(
        position: event,
        canChoolCheck: distance <= 100,
      );
    });
  }

  void setChoolCheckDone(bool done) {
    state = state.copyWith(choolCheckDone: done);
  }
}
