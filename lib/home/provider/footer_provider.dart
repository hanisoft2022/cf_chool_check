import 'package:chool_check/home/provider/location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FooterState {
  final String message;
  final IconData? iconData;
  final Color iconColor;
  final bool showCheckButton;

  FooterState({
    this.message = '',
    this.iconData,
    this.iconColor = Colors.blue,
    this.showCheckButton = false,
  });

  FooterState copyWith({
    String? message,
    IconData? iconData,
    Color? iconColor,
    bool? showCheckButton,
  }) {
    return FooterState(
      message: message ?? this.message,
      iconData: iconData ?? this.iconData,
      iconColor: iconColor ?? this.iconColor,
      showCheckButton: showCheckButton ?? this.showCheckButton,
    );
  }
}

final footerProvider = StateNotifierProvider<FooterNotifier, FooterState>((ref) {
  return FooterNotifier(ref);
});

class FooterNotifier extends StateNotifier<FooterState> {
  final Ref ref;

  FooterNotifier(this.ref) : super(FooterState()) {
    // locationProvider의 상태 변화 감지
    ref.listen(locationProvider, (previous, next) {
      _updateFooterState(next);
    });
  }

  void _updateFooterState(LocationState locationState) {
    if (!locationState.canChoolCheck) {
      state = FooterState(
        message: '출석 가능한 범위 밖입니다. \n 출석을 위해 지도 상의 빨간색 원 안으로 이동해 주세요.',
        iconData: null,
        iconColor: Colors.red,
        showCheckButton: false,
      );
    } else if (!locationState.choolCheckDone) {
      state = FooterState(
        iconData: Icons.timelapse,
        iconColor: Colors.blue,
        showCheckButton: true,
      );
    } else {
      state = FooterState(
        iconData: Icons.check,
        iconColor: Colors.green,
        showCheckButton: false,
      );
    }
  }

  Future<void> showCheckInDialog(BuildContext context) async {
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
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              label: const Text('아니요'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.check),
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              label: const Text('예'),
            ),
          ],
        );
      },
    );

    if (result) {
      ref.read(locationProvider.notifier).setChoolCheckDone(true);
    }
  }
}
