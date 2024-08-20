import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/ingredient_recognition/line_animations.dart';
import 'package:google_fonts/google_fonts.dart';


// googlefonts.lato, googlefonts.roboto
// Text styles

TextStyle googleFonts(
  final double fontSize, 
  {
    final Color? color, 
    final bool? shadow, 
    final double? offset, 
    final Color? shadowColor,
    final bool? isPressed
  }
) {
  final bool isPressedLocal = isPressed ?? false;
  final bool localShadow = (shadow!=null && shadow!=false) || shadow==null;
  return GoogleFonts.inter(
    textStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      letterSpacing: 0,
      wordSpacing: 0,
      height: 1.5,
      color: color ?? Colors.white, // default to white
      shadows: localShadow ? [
        isPressedLocal ? const Shadow() : Shadow(// if the text is "pressed" remove the shadow
          // offset and blurradius are a function of fontsize if not provided
          offset: Offset(offset ?? fontSize/15 + .4, offset ?? fontSize/15 + .4),
          blurRadius: offset ?? fontSize/15 + .4,
          color: shadowColor ?? 
              ((color==null || color != Colors.black) ? 
              Colors.black : Colors.white),
        ),
      ] : null,
    )
  );
}

// get the styled text and the status based on the text

class StatusStyledTextReturn {
  final Status status;
  final TextSpan styledText;
  final List<LineData>? lines;

  StatusStyledTextReturn(this.status, this.styledText, this.lines);
}

StatusStyledTextReturn getStyledText(final List<String> list, final String endText) {
  final List<TextSpan> spans = [];
  Status localStatus = Status.none;
  for (int i=0; i<list.length; i++) {
    final StatusStyledWordReturn returnVal = getStyledWord(list[i], localStatus, i==list.length-1);
    localStatus = returnVal.status ?? localStatus;
    spans.add(returnVal.word);
  }
  spans.add(TextSpan(text: endText, style: googleFonts(17, color:Colors.black)));
  return StatusStyledTextReturn(
    localStatus,
    TextSpan(children: spans),
    null
  );
}

class StatusStyledWordReturn {
  final Status? status;
  final TextSpan word;
  final Color color;

  StatusStyledWordReturn(this.status, this.word, this.color);
}

StatusStyledWordReturn getStyledWord(final String word, final Status currentStatus, final bool end) {
  Status? returnStatus;
  late TextSpan returnWord;
  late Color color;
  final String modifiedWord = removePrefixes(word);
  if (isRedWord(modifiedWord)) {
    returnStatus = Status.doesntFit;
    returnWord = TextSpan(text: word, style: googleFonts(17, color:Colors.red));
    color = Colors.red;
  } else if (isOrangeWord(modifiedWord)) {
    if(currentStatus!=Status.doesntFit) {
      returnStatus = Status.possiblyFits;
    }
    returnWord = TextSpan(text: word, style: googleFonts(17, color:Colors.orange));
    color = Colors.orange;
  } else {
    if(currentStatus==Status.none) {
      returnStatus = Status.doesFit;
    }
    returnWord = TextSpan(text: word, style: googleFonts(17, color:Colors.black));
    color = Colors.green;
  }
  // Create a new TextSpan to append the comma if the end has not been reached
  if (!end) {
    returnWord = TextSpan(
      children: <TextSpan>[
        returnWord,
        TextSpan(text: ',', style: googleFonts(17, color:Colors.black))
      ]
    );
  }
  return StatusStyledWordReturn(
    returnStatus, 
    returnWord,
    color
  );
}