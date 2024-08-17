import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/ingredient_recognition/line_animations.dart';

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
  spans.add(TextSpan(text: endText, style: kStyle4(Colors.black)));
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
    returnWord = TextSpan(text: word, style: kStyle4(Colors.red));
    color = Colors.red;
  } else if (isOrangeWord(modifiedWord)) {
    if(currentStatus!=Status.doesntFit) {
      returnStatus = Status.possiblyFits;
    }
    returnWord = TextSpan(text: word, style: kStyle4(Colors.orange));
    color = Colors.orange;
  } else {
    if(currentStatus==Status.none) {
      returnStatus = Status.doesFit;
    }
    returnWord = TextSpan(text: word, style: kStyle4(Colors.black));
    color = Colors.green;
  }
  // Create a new TextSpan to append the comma if the end has not been reached
  if (!end) {
    returnWord = TextSpan(
      children: <TextSpan>[
        returnWord,
        TextSpan(text: ',', style: kStyle4(Colors.black))
      ]
    );
  }
  return StatusStyledWordReturn(
    returnStatus, 
    returnWord,
    color
  );
}