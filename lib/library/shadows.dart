import 'package:flutter/material.dart';

BoxShadow globalShadow({final Color? color}) {
  const bool elevated = true;
  return BoxShadow(
    color: color ?? Colors.white.withOpacity(0.5),
    // spreadRadius: elevated ? 1 : 0,
    offset: Offset(elevated ? 2 : 0, elevated ? 2 : 0),
    blurRadius: 1,
  );
}