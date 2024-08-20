import 'package:flutter/material.dart';

// colorReturner 
class ColorReturner {
  final Color primary;
  final Color secondary;
  final Color primaryFixed;
  final Color secondaryFixed;
  final Color backGroundColor;
  final Color bottombarColor;

  ColorReturner() //
      : primary = const Color.fromARGB(255, 0, 121, 150),
      // : primary = const Color.fromARGB(255, 0, 104, 118),
        // primaryFixed = const Color.fromARGB(255, 161, 239, 255),
        primaryFixed = const Color.fromARGB(255, 224, 130, 0),
        // primaryFixed = const Color.fromARGB(255, 239, 134, 22),
        secondary = const Color.fromARGB(255, 74, 98, 104),
        // secondaryFixed = const Color.fromARGB(255, 205, 231, 237);
        secondaryFixed = const Color.fromARGB(255, 244, 251, 252),
        backGroundColor = const Color.fromARGB(255, 0, 73, 83),
        bottombarColor = const Color.fromARGB(255, 0, 73, 83);
        // bottombarColor = const Color.fromARGB(255, 0, 104, 118);
        // bottombarColor = const Color.fromARGB(255, 161, 151, 177)
}