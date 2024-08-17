import 'package:flutter/material.dart';

// googlefonts.lato, googlefonts.roboto
// Text styles
TextStyle kStyle1(final Color color) {
  return TextStyle(
    color: color,
    fontSize: 20,
    fontWeight: FontWeight.w100,
  );
}
TextStyle kStyle2(final Color color) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w100,
    fontSize: 15.0,
  );
}
TextStyle kStyle3(final Color color) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w100,
    fontSize: 30.0,
  );
}
TextStyle kStyle4(final Color color) {
  return TextStyle(
    color: color,
    fontSize: 16,
    letterSpacing: 0,
    height: 1.2,
  );
}
const TextStyle kStyle5black = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 18.0,
);