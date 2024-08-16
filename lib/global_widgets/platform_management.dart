import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library.dart';

class PlatformWidget extends StatelessWidget {
  final WidgetBuilder ios;
  final WidgetBuilder android;

  const PlatformWidget({required this.ios, required this.android});

  @override
  Widget build(final BuildContext context) {
    return isAndroid() ? android(context) : ios(context);
  }
}