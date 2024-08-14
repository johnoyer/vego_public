import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
// ignore: unused_import
import 'package:platform/platform.dart';

// Status
enum Status {
  doesntFit,
  possiblyFits,
  doesFit,
  none
}

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

// Height of the uppermost box
const double upperHeight = 400;
const double upperHeightSecondary = 220;
// const double dividerSize = 5;

RoundedRectangleBorder globalBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0), 
  side: const BorderSide(color: Color.fromARGB(255, 4, 3, 49))
);

// Dialogs 

// showErrorMessage (Used for multiple errors)
void showErrorMessage(final BuildContext context, final String text) {
  isAndroid() ? showDialog(
    context: context,
    builder: (final BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('Error')),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      );
    },
  ) : showCupertinoDialog(
    context: context,
    builder: (final BuildContext context) {
      return CupertinoAlertDialog(
        title: const Center(child: Text('Error')),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showAlert(final BuildContext context, final int numSeconds, final String mainText, {final String? secondaryText}) {
  isAndroid() ? showDialog(
    context: context,
    builder: (final context) => AlertDialog(
      title: Text(mainText),
      content: secondaryText!=null ? Text(secondaryText) : null,
    )
  ) : showCupertinoDialog(
    context: context,
    builder: (final context) => CupertinoAlertDialog(
      title: Text(mainText),
      content: secondaryText!=null ? Text(secondaryText) : null,
    ),
  );
  // Automatically dismiss the AlertDialog after a few seconds
  Future.delayed(Duration(seconds: numSeconds), () {
    Navigator.of(context).pop();
  });
}

// String processing functions

bool isRedWord(final String word) {
  if(DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList==null) {
    throw StateError('canBeConformingIngredientsCompleteList has not been established');
  } else if(DietState().getIngredientInfo()!.nonConformingIngredientsCompleteList==null
    && DietState().getIngredientInfo()!.conformingIngredientsCompleteList==null) {
    throw StateError('neither nonConformingIngredientsCompleteList nor conformingIngredientsCompleteList has been established');
  }
  final bool inCanBeConformingList = DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList
      !.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase());
  final bool inNonConformingList = DietState().getIngredientInfo()!.nonConformingIngredientsCompleteList
      ?.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase()) ?? false;
  final bool inConformingList = DietState().getIngredientInfo()!.conformingIngredientsCompleteList
      ?.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase()) ?? true;
  // Returns true if the ingredient is nonconforming, or it is not conforming and not possibly conforming
  return inNonConformingList || (!inConformingList&&!inCanBeConformingList);
}

bool isOrangeWord(final String word) {
  if(DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList==null) {
    throw StateError('canBeConformingIngredientsCompleteList has not been established');
  }
  final bool inCanBeConformingList = DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList
      !.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase());
  // Returns true if the ingredient can be conforming
  return inCanBeConformingList;
}

String removePrefixes(String ingredient) {
  final RegExp removePatterns = RegExp(r'\b(?:atlantic|concentrated|dehydrated|dried|emulsifier|enriched|extract|expeller pressed|for freshness|for quality|freeze-dried|fresh|fried|ground|juice|isolate|lake|minced|malted|melted|organic|pacific|pitted|powdered|preserved|pressed|processed|reduced|roasted|salted|unbleached|)\b', caseSensitive: false);
  ingredient = ingredient.replaceAll(',',''); // Remove commas
  ingredient = ingredient.replaceAll('(',''); // Remove parenthesis 
  ingredient = ingredient.replaceAll(')',''); // Remove parenthesis
  ingredient = ingredient.replaceAll('*',''); // Remove asterisks
  ingredient = ingredient.replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
  return ingredient.replaceAll(removePatterns, '').trim();
}

String capitalizeFirstLetter(final String input) {
  return input.split(' ').map((final word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

List<String> capitalizeFirstLetterOfEveryWord(final List<String> inputList) {
  return inputList.map((final str) => capitalizeFirstLetter(str)).toList();
}

List<String> lowerCaseEveryWord(final List<String> inputList) {
  return inputList.map((final str) => str.toLowerCase().trim()).toList();
}

// colorReturner 
class ColorReturner {
  final Color primary;
  final Color secondary;
  final Color primaryFixed;
  final Color secondaryFixed;

  ColorReturner({final ThemeData? theme}) // Theme from Colors.cyan
      : primary = theme?.colorScheme.primary ?? const Color.fromARGB(255, 0, 104, 118),
        primaryFixed = theme?.colorScheme.primaryFixed ?? const Color.fromARGB(255, 161, 239, 255),
        secondary = theme?.colorScheme.secondary ?? const Color.fromARGB(255, 74, 98, 104),
        secondaryFixed = theme?.colorScheme.secondaryFixed ?? const Color.fromARGB(255, 205, 231, 237);
}
  

// isAndroid (Used to determine platform)

bool isAndroid() {
    // if (const LocalPlatform().isIOS) {
    //   return ios(context);
    // else if (const LocalPlatform().isAndroid) {
    //   return android(context);
    // }
    // Default to Android if the platform is neither iOS nor Android
  return false;
}