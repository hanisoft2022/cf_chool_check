import 'package:chool_check/home/provider/footer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WStatusIcon extends ConsumerWidget {
  const WStatusIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(footerProvider);

    if (state.iconData != null) {
      return Icon(state.iconData, color: state.iconColor);
    }
    return Text('!', style: TextStyle(fontWeight: FontWeight.bold, color: state.iconColor));
  }
}
