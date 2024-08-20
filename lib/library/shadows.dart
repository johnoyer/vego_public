import 'package:flutter/material.dart';

BoxShadow globalShadow(final bool isPressed, {final Color? color, final double? blurRadius}) {
  return BoxShadow(
    color: color ?? Colors.white.withOpacity(0.5),
    offset: Offset(isPressed ? 0 : 2, isPressed ? 0 : 2),
    blurRadius: blurRadius ?? 1,
  );
}