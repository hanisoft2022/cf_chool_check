import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chool_check/home/provider/app_bar_provider.dart';

class FCustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const FCustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(128),
      title: const Text('출근 출석하기!', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          color: Colors.blue,
          onPressed: () => ref.read(appBarProvider.notifier).moveToCurrentLocation(),
          icon: const Icon(Icons.my_location),
        ),
      ],
    );
  }
}
