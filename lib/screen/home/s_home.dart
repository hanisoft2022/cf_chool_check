import 'package:chool_check/const/markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  // initState에서 위치 초기화 메서드 담고
  // FutureBuilder의 future 파라미터에 넣을 변수
  late Future<Position> _determinePositionFuture;

  // 맵 컨트롤러
  late final GoogleMapController controller;

  // 초기 카메라 위치
  // 원종초등학교
  // cf. 디바이스 설정 위치는 우리 집
  final CameraPosition _initialCameraPosition = const CameraPosition(
      target: LatLng(
        37.51824327980506,
        126.80642272189212,
      ),
      zoom: 15);

  // 출첵 완료 여부 boolean 값
  bool choolCheckDone = false;

  // 출석 가능 위치 여부 boolean 값
  bool canChoolCheck = false;

  // 출근 중심지로부터의 거리
  final double _distanceFromOfficeCenter = 100;

  // 위치 기능 활성화 확인 -> 권한 활성화 확인 -> 클라이언트 현재 위치 리턴

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 기능 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 기능을 활성화해주세요.');
    }

    // 위치 권한 활성화 여부 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한을 허용해주세요.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 위치 권한이 영구적으로 거절됨
      return Future.error(
        '위치 권한이 거절되었습니다. \n\'설정\'앱에서 위치 권한을 허용해주세요.',
      );
      // throw 'dds';
    }

    // 현재 위치값을 포함한 Position 인스턴스 리턴
    return await Geolocator.getCurrentPosition();
  }

  // 앱바의 myLocation 아이콘 버튼 눌러서 사용자의 현재 위치로 이동하는 메서드
  onAppBarButtonPressedToGetMyLocation() async {
    final myLocation = await Geolocator.getCurrentPosition();
    controller.animateCamera(
      // zoom 재정의
      // CameraUpdate.newCameraPosition(
      //   CameraPosition(
      //     target: LatLng(
      //       myLocation.latitude,
      //       myLocation.longitude,
      //     ),
      //     zoom: 16,
      //   ),
      // ),

      // 기존 zoom 유지한 채로 카메라 이동
      CameraUpdate.newLatLng(
        LatLng(
          myLocation.latitude,
          myLocation.longitude,
        ),
      ),
    );
  }

  // '출석하기' 버튼 눌렀을 때의 출석하기 dialog 띄우는 메서드
  onChoolCheckPressed() async {
    final bool result = await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('출석하겠습니까?'),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.cancel),
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              label: const Text('아니요'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.check),
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              label: const Text('예'),
            ),
          ],
        );
      },
    );

    setState(() => choolCheckDone = result);
  }

  // 지도 하단부 상황별 icon
  Widget _buildStatusIcon() {
    if (canChoolCheck) {
      return Icon(
        choolCheckDone ? Icons.check : Icons.timelapse,
        color: choolCheckDone ? Colors.green : Colors.blue,
      );
    } else {
      return const Text(
        '!',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      );
    }
  }

  // 지도 하단부 상황별 메시지
  Widget _buildStatusMessage() {
    if (!canChoolCheck) {
      return const Text(
        '출석 가능한 범위 밖입니다. \n 출석을 위해 지도 상의 빨간색 원 안으로 이동해 주세요.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red),
      );
    } else if (!choolCheckDone) {
      return OutlinedButton.icon(
        icon: const Icon(Icons.check),
        onPressed: onChoolCheckPressed,
        label: const Text('출석하기'),
        style: OutlinedButton.styleFrom(
          iconColor: Colors.blue,
          foregroundColor: Colors.blue,
          side: const BorderSide(color: Colors.blue),
        ),
      );
    }
    return const SizedBox.shrink(); // 출석 완료 시 빈 위젯 반환
  }

  // initState에서 실시간 사용자 위치 반영 메서드 초기화
  @override
  void initState() {
    super.initState();
    _determinePositionFuture = _determinePosition();
    // 실시간 사용자 위치 반영
    Geolocator.getPositionStream().listen(
      (event) {
        final officeCenterLatLng = markers['원종초등학교']!.position;

        final currentLatLng = LatLng(event.latitude, event.longitude);

        final distanceBetweenOfficeCenterAndCurrentLatLng = Geolocator.distanceBetween(
          officeCenterLatLng.latitude,
          officeCenterLatLng.longitude,
          currentLatLng.latitude,
          currentLatLng.longitude,
        );

        setState(
          () {
            if (distanceBetweenOfficeCenterAndCurrentLatLng > _distanceFromOfficeCenter) {
              canChoolCheck = false;
            } else {
              canChoolCheck = true;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.5),
        title: const Text(
          '출근 출석하기!',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.blue,
            onPressed: onAppBarButtonPressedToGetMyLocation,
            icon: const Icon(
              Icons.my_location,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _determinePositionFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }

          final setCircles = {
            Circle(
              circleId: const CircleId(
                '원종초 출근 인정 범위',
              ),
              // 원종초등학교 위도 경도
              center: markers['원종초등학교']!.position,
              radius: _distanceFromOfficeCenter,
              strokeWidth: 1,
              fillColor: canChoolCheck ? Colors.blue.withOpacity(0.5) : Colors.red.withOpacity(0.5),
              strokeColor: canChoolCheck ? Colors.blue.withOpacity(0.5) : Colors.red.withOpacity(0.5),
            ),
          };

          Set<Marker> setMarkers = {
            markers['원종초등학교']!,
          };

          return Column(
            children: [
              Expanded(
                flex: 3,
                child: _Body(
                  onMapCreated: (controller) {
                    this.controller = controller;
                  },
                  initialCameraPosition: _initialCameraPosition,
                  setMarkers: setMarkers,
                  setCircles: setCircles,
                ),
              ),
              Expanded(
                flex: 1,
                child: _Footer(
                  buildStatusIcon: _buildStatusIcon(),
                  buildStatusMessage: _buildStatusMessage(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final MapCreatedCallback onMapCreated;
  final CameraPosition initialCameraPosition;
  final Set<Marker> setMarkers;
  final Set<Circle> setCircles;

  const _Body({
    required this.onMapCreated,
    required this.initialCameraPosition,
    required this.setMarkers,
    required this.setCircles,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: initialCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: setMarkers,
      circles: setCircles,
    );
  }
}

class _Footer extends StatelessWidget {
  final Widget buildStatusIcon;
  final Widget buildStatusMessage;

  const _Footer({
    required this.buildStatusIcon,
    required this.buildStatusMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildStatusIcon,
        const Gap(20),
        buildStatusMessage,
      ],
    );
  }
}
