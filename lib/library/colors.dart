import 'package:flutter/material.dart';

// colorReturner 
class ColorReturner {
  final Color primary;
  final Color secondary;
  final Color primaryFixed;
  final Color secondaryFixed;
  final Color backGroundColor;

  ColorReturner({final ThemeData? theme}) // Theme from Colors.cyan
      : primary = theme?.colorScheme.primary ?? const Color.fromARGB(255, 0, 104, 118),
        // primaryFixed = theme?.colorScheme.primaryFixed ?? const Color.fromARGB(255, 161, 239, 255),
        primaryFixed = theme?.colorScheme.primaryFixed ?? const Color.fromARGB(255, 239, 134, 22),
        secondary = theme?.colorScheme.secondary ?? const Color.fromARGB(255, 74, 98, 104),
        // secondaryFixed = theme?.colorScheme.secondaryFixed ?? const Color.fromARGB(255, 205, 231, 237);
        secondaryFixed = theme?.colorScheme.secondaryFixed ?? const Color.fromARGB(255, 244, 251, 252),
        backGroundColor = const Color.fromARGB(255, 0, 104, 118);
}