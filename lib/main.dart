import 'package:chool_check/home/screen/s_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SHome(),
  )));
}
