import 'package:chool_check/home/provider/footer_provider.dart';
import 'package:chool_check/home/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WStatusMessage extends ConsumerWidget {
  const WStatusMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(footerProvider);
    final notifier = ref.read(footerProvider.notifier);
    final locationState = ref.watch(locationProvider);

    if (!locationState.canChoolCheck) {
      return Text('출석 가능한 범위 밖입니다. \n 출석을 위해 지도 상의 빨간색 원 안으로 이동해 주세요.', textAlign: TextAlign.center, style: TextStyle(color: state.iconColor));
    }

    if (!locationState.choolCheckDone) {
      return OutlinedButton.icon(
        icon: const Icon(Icons.check),
        onPressed: () => notifier.showCheckInDialog(context),
        label: const Text('출석하기'),
        style: OutlinedButton.styleFrom(iconColor: Colors.blue, foregroundColor: Colors.blue, side: const BorderSide(color: Colors.blue)),
      );
    }

    return const SizedBox.shrink();
  }
}
