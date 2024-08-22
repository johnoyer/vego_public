import 'package:flutter/material.dart';

BoxShadow globalShadow(final bool isPressed, {final Color? color, final double? blurRadius, final bool? elevated, final double? offset}) {
  return isPressed ? const BoxShadow() : BoxShadow(
    color: color ?? Colors.white.withOpacity(0.5),
    // offset: Offset(isPressed ? 0 : 2, isPressed ? 0 : 2),
    offset: Offset(offset ?? 2, offset ?? 2),
    blurRadius: blurRadius ?? (isPressed ? 0 : 1),
    // spreadRadius: (elevated!=null&&elevated
  );
}