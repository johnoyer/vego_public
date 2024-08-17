import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/ingredient_recognition/line_animations.dart';

Future<void> spellCheck() async {
  const Locale locale = Locale('en', 'US');
  final DefaultSpellCheckService spellCheckService = DefaultSpellCheckService();
  for(String ingredient in DietState().getIngredientInfo()!.persistentIngredientsList!) {
    final List<SuggestionSpan>? suggestionList = await spellCheckService.fetchSpellCheckSuggestions(locale, ingredient);
    if(suggestionList!=null) {
      for(SuggestionSpan suggestionSpan in suggestionList) {
        if (suggestionSpan.suggestions.isNotEmpty) {
          // Access the first suggestion
          final String bestSuggestion = suggestionSpan.suggestions.first;
          print('bestSuggestion: $bestSuggestion');
          print('all suggestions: ${suggestionSpan.suggestions}');
          ingredient = ingredient.replaceRange(suggestionSpan.range.start, suggestionSpan.range.end, bestSuggestion);
        }
      }
    }
  }
}

// Ingredient Processing functions below

class TrimReturn {
  final String shortenedText;
  final bool trimBeginning;
  final bool trimEnd;

  TrimReturn(this.shortenedText, this.trimBeginning, this.trimEnd);
}

const List<String> beginningKeywords = ['ingredients', 'lngredients', 'ingredlents', 'lngredlents'];
const List<String> endKeywords = ['contains', 'caution', '.'];

TrimReturn trim(final String fullText) {
  bool trimBeginning = false;
  bool trimEnd = false;

  // shortenedText will result from isolating the ingredients
  String shortenedText = fullText.toLowerCase();


  // First step (trimming): remove 'ingredients' and everything before it, if possible
  int beginningIndex = -1;
  
  for(String beginningKeyword in beginningKeywords) {
    final int keywordIndex = fullText.toLowerCase().indexOf(beginningKeyword);
    if (keywordIndex > beginningIndex) { // check if the string contains keyword
      beginningIndex = keywordIndex;
    }
  }

  if(beginningIndex!=-1) { 
    trimBeginning = true;
    shortenedText = fullText.substring(beginningIndex+11).trim();
  }
  shortenedText = shortenedText.replaceAll(':','').trim(); // remove colon(s)

  // Second step (trimming): find indicators of the end of the ingredient list, trimming if possible
  int endIndex = shortenedText.length;

  for(String endKeyword in endKeywords) {
    final int keywordIndex = shortenedText.toLowerCase().indexOf(endKeyword);
    if (keywordIndex != -1 && keywordIndex < endIndex) { // check if the string contains keyword
      endIndex = keywordIndex;
    }
  }
  trimEnd = (endIndex != shortenedText.length);
  shortenedText = shortenedText.substring(0, endIndex).trim(); // cut down string if keyword found

  return TrimReturn(shortenedText, trimBeginning, trimEnd);
}

enum SeparationStyle {
  commaSeparated, 
  indentationSeparated,
  none
}

SeparationStyle determineSeparationStyle(final String shortenedText) {
  final String alteredText = shortenedText.replaceAll(RegExp(r'\([^)]*\)'), ''); // remove everything within parenthesis
  final List<String> words = alteredText.split(' '); // split text into words
  final int i = min(6, words.length);

  final List<String> firstFewWords = words.take(i).toList(); // check if first few words in the list contain a comma
  final bool containsComma = firstFewWords.any((final word) => word.contains(','));
  if(containsComma) {
    return SeparationStyle.commaSeparated;
  } else {
    return SeparationStyle.indentationSeparated;
  }
}

class IndicesReturn {
  final int startingIndexTextAnnotations;
  final int endingIndexTextAnnotations;

  IndicesReturn(this.startingIndexTextAnnotations, this.endingIndexTextAnnotations);
}

IndicesReturn findIndices(final dynamic textAnnotations, final bool trimBeginning, final bool trimEnd) {
  int startingIndexTextAnnotations = 1;
  int endingIndexTextAnnotations = textAnnotations.length;
  if(textAnnotations.length<=1) {
    throw RangeError;
  }
  if(trimBeginning) {
    for(int i=1; i<textAnnotations.length; i++) { 
      for(String beginningKeyword in beginningKeywords) {
        if(textAnnotations[i]['description'].toLowerCase().contains(beginningKeyword) && startingIndexTextAnnotations == 1) {
          startingIndexTextAnnotations = i+1;
        }
      }
    }
  }
  if(trimEnd) {
    for(int i=startingIndexTextAnnotations; i<textAnnotations.length; i++) { 
      for(String endKeyword in endKeywords) {
        if(textAnnotations[i]['description'].toLowerCase().contains(endKeyword) && endingIndexTextAnnotations == textAnnotations.length) {
          endingIndexTextAnnotations = i;
        }
      }
    }
  }
  return IndicesReturn(startingIndexTextAnnotations, endingIndexTextAnnotations);
}

List<String> handleSeparation(final String shortenedText, final SeparationStyle separationStyle) {
  late String localShortenedText;
  if(separationStyle==SeparationStyle.commaSeparated) {
    localShortenedText = shortenedText.replaceAll('\n',' '); // Remove newlines if ingredients are comma separated
  } else {
    localShortenedText = shortenedText.replaceAll('\n', ', '); // Replace newlines with commas if ingredients are separation by newlines
  }
  localShortenedText = localShortenedText.replaceAll('(',','); // Replace parenthesis with commas
  localShortenedText = localShortenedText.replaceAll(')',','); // Replace parenthesis with commas
  // Convert the String into a List<String> by splitting by comma
  final List<String> shortenedTextlistFormat = localShortenedText.split(',').map((final word)=> word.trim()).toList();
  return shortenedTextlistFormat;
}

StatusStyledTextReturn addLinesAndDetermineStatus(final List<String> shortenedTextListFormat, final List<String> wordList, final List<double> xInitialList, final List<double> yInitialList, final List<double> xFinalList, final List<double> yFinalList) {
  final List<LineData> lines = [];
  final List<TextSpan> spans = [];
  Status localStatus = Status.none;

  // Correcting the wordList and shortenedTextListFormat by removing extra characters

  for(int i=0; i<wordList.length; i++) {
    wordList[i] = wordList[i].replaceAll(':',''); // Remove colons
    wordList[i] = wordList[i].replaceAll(',',''); // Remove commas
    wordList[i] = wordList[i].replaceAll('(',''); // Remove parenthesis
    wordList[i] = wordList[i].replaceAll(')',''); // Remove parenthesis
    wordList[i] = wordList[i].replaceAll(RegExp(r'\s+'), ' '); // Remove multiple spaces (replace with single space)
    wordList[i] = wordList[i].toLowerCase().trim(); // Trim, make lowercase
  }

  for(int i=0; i<shortenedTextListFormat.length; i++) {
    shortenedTextListFormat[i] = shortenedTextListFormat[i].replaceAll(':',''); // Remove colons
    shortenedTextListFormat[i] = shortenedTextListFormat[i].replaceAll(',',''); // Remove commas
    shortenedTextListFormat[i] = shortenedTextListFormat[i].replaceAll('(',''); // Remove parenthesis
    shortenedTextListFormat[i] = shortenedTextListFormat[i].replaceAll(')',''); // Remove parenthesis
    shortenedTextListFormat[i] = shortenedTextListFormat[i].replaceAll(RegExp(r'\s+'), ' '); // Remove multiple spaces (replace with single space)
    shortenedTextListFormat[i] = shortenedTextListFormat[i].toLowerCase().trim(); // Trim, make lowercase
    if(shortenedTextListFormat[i]=='') {
      shortenedTextListFormat.removeAt(i);
      i--;
    }
  }

  int currentIndexWordList = 0;
  for (int i=0; i<shortenedTextListFormat.length; i++) { // Iterate through every ingredient in the list of ingredients
    final String currentIngredient = shortenedTextListFormat[i];
    final StatusStyledWordReturn returnVal = getStyledWord(currentIngredient, localStatus, i==shortenedTextListFormat.length-1);
    localStatus = returnVal.status ?? localStatus;
    spans.add(returnVal.word);
    final Color color = returnVal.color;

    bool lastWordFound = false;
    int currentIngredientIndex = 0; // Used to track where in the ingredient list the loop is considering
    while(lastWordFound==false && currentIndexWordList<wordList.length) { // Both conditions should never occur
      final String description = wordList[currentIndexWordList];
      if(!currentIngredient.contains(description, currentIngredientIndex)) {
        lastWordFound = true;
        break;
      }
      currentIngredientIndex = currentIngredient.indexOf(description, currentIngredientIndex) + description.length;
      if(currentIngredientIndex>=currentIngredient.length+1) {
        lastWordFound = true;
        break;
      }
      final double xInitial = xInitialList[currentIndexWordList];
      final double yInitial = yInitialList[currentIndexWordList];
      final double xFinal = xFinalList[currentIndexWordList];
      final double yFinal = yFinalList[currentIndexWordList];
      lines.add(LineData(Offset(xInitial,yInitial),Offset(xFinal,yFinal),color));
      currentIndexWordList++;
    }
  }
  return StatusStyledTextReturn(
    localStatus,
    TextSpan(children: spans),
    lines
  );
}