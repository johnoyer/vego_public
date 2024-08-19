import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// googlefonts.lato, googlefonts.roboto
// Text styles

TextStyle googleFonts(final double fontSize, {final Color? color, final bool? shadow, final double? offset, final Color? shadowColor}) {
  return GoogleFonts.inter(
    textStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color ?? Colors.white, // default to white
      shadows: (shadow!=null && shadow!=false) ? [
        Shadow(
          // offset and blurradius are a function of fontsize if not provided
          offset: Offset(offset ?? fontSize/15 + .4, offset ?? fontSize/15 + .4),
          blurRadius: offset ?? fontSize/15 + .4,
          color: shadowColor ?? 
              ((color==null || color == Colors.white) ? 
              Colors.black : Colors.white),
        ),
      ] : null,
    )
  );
}