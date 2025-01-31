import 'package:chool_check/home/provider/footer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class FFooter extends ConsumerWidget {
  const FFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(footerProvider);
    final notifier = ref.read(footerProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusIcon(state),
        const Gap(20),
        _buildStatusMessage(context, state, notifier),
      ],
    );
  }
}

Widget _buildStatusIcon(FooterState state) {
  if (state.iconData != null) {
    return Icon(
      state.iconData,
      color: state.iconColor,
    );
  }
  return Text(
    '!',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: state.iconColor,
    ),
  );
}

Widget _buildStatusMessage(
  BuildContext context,
  FooterState state,
  FooterNotifier notifier,
) {
  if (state.message.isNotEmpty) {
    return Text(
      state.message,
      textAlign: TextAlign.center,
      style: TextStyle(color: state.iconColor),
    );
  }

  if (state.showCheckButton) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.check),
      onPressed: () => notifier.showCheckInDialog(context),
      label: const Text('출석하기'),
      style: OutlinedButton.styleFrom(
        iconColor: Colors.blue,
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
      ),
    );
  }

  return const SizedBox.shrink();
}
