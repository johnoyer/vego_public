import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:platform/platform.dart';

class PlatformWidget extends StatelessWidget {
  final WidgetBuilder ios;
  final WidgetBuilder android;

  const PlatformWidget({required this.ios, required this.android});

  @override
  Widget build(final BuildContext context) {
    return isAndroid() ? android(context) : ios(context);
  }
}

// isAndroid (Used to determine platform)

bool isAndroid() {
    // if (const LocalPlatform().isIOS) {
    //   return ios(context);
    // else if (const LocalPlatform().isAndroid) {
    //   return android(context);
    // }
    // Default to Android if the platform is neither iOS nor Android
  return false;
}