import 'package:flutter/material.dart';

// Used to enclose diet icons

Widget dietIconWrapper(final Widget child) {
  return Container(
    width: 30.0,
    height: 30.0,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle, // Make the container circular
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(142, 0, 0, 0),
          // offset: Offset(0, 4), // Shadow offset
          blurRadius: 6, // Blur radius of the shadow
          // spreadRadius: 0, // Spread radius of the shadow
        ),
      ],
    ),
    child: child
  );
}