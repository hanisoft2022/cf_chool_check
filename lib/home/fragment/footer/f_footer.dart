import 'package:chool_check/home/fragment/footer/widget/w_status_icon.dart';
import 'package:chool_check/home/fragment/footer/widget/w_status_message.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FFooter extends StatelessWidget {
  const FFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WStatusIcon(),
        Gap(20),
        WStatusMessage(),
      ],
    );
  }
}
