import 'package:chool_check/home/fragment/f_custom_app_bar.dart';
import 'package:chool_check/home/provider/location_provider.dart';
import 'package:chool_check/home/fragment/f_body.dart';
import 'package:chool_check/home/fragment/f_footer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SHome extends ConsumerStatefulWidget {
  const SHome({super.key});

  @override
  ConsumerState<SHome> createState() => _SHomeState();
}

class _SHomeState extends ConsumerState<SHome> {
  // initState에서 실시간 사용자 위치 반영 메서드 초기화
  @override
  void initState() {
    super.initState();
    ref.read(locationProvider.notifier).determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationProvider);

    if (state.position == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: FCustomAppBar(),
      body: Column(
        children: [
          Expanded(flex: 3, child: FBody()),
          Expanded(flex: 1, child: FFooter()),
        ],
      ),
    );
  }
}
