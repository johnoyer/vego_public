import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/global_widgets/cards.dart';
import 'package:vego_flutter_project/global_widgets/button.dart';

// buildDietInfo (Used in ingredient recognition and in manual entry)

Widget buildDietInfo(final BuildContext context) {
  return Consumer<DietState>(
    builder: (final context, final dietState, final child) {
      if (DietState().getStatus()==Status.none) {//status.none
        // Handle the case where status is none
        return Center(
          child: libraryCard('Enter an Ingredient to Get Started!', TextFeatures.normal),
        );
      }

      Color color = Colors.black;
      IconData iconData = Icons.hourglass_empty;

      final List<String> dietNames = [];

      for (Diet diet in DietState.getDietList()) {
        if(diet.isChecked) {
          dietNames.add(diet.name);
        }
      }

      final int count = dietNames.length;
      // String dietText = 'These ingredients are ';
      String dietText = '';

      if(DietState().getStatus()==Status.doesntFit) { // There are non conforming ingredients
        color = Colors.red;
        iconData = Icons.clear;
        dietText += 'Not ';
      } else if(DietState().getStatus()==Status.possiblyFits) { // Above is false, but there are possibly conforming ingredients
        color = Colors.orange;
        iconData = Icons.help;
        dietText += 'Possibly ';
      } else if(DietState().getStatus()==Status.doesFit) { // Both above are false: diet conforms
        color = Colors.green;
        iconData = Icons.check;
      }
      if(count==1) {
        dietText += dietNames[0];  
      } else if(count==2) {
        dietText += '${dietNames[0]} and ${dietNames[1]}';
      } else {
        String prefix = '';
        for (int i = 0; i < count - 1; i++) {
          prefix += '${dietNames[i]}, ';
        }
        prefix += 'and ${dietNames[count - 1]}';
        dietText += prefix;
      }
      late String shortenedDietText;
      if(dietText.length > 22) {
        shortenedDietText = '${dietText.substring(0, 20)}...'; // if the text is too long, shorten the displayed text
      } else {
        shortenedDietText = dietText;
      }

      const double iconSize = 80;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(iconSize/2),
              boxShadow: [
                globalShadow(
                  false,
                  offset: 1,
                  blurRadius: 1,
                ),
              ],
              border: Border.all(
                // color: Colors.black,
                width: 1.5
              ),
            ),
            child: Center(
              child: Icon(
                iconData,
                size: iconSize*.9,
                color: Colors.white,
              ),
            ),
          ),
          LibraryButton(
            onTap: () {
              print('arrived');
            },
            childBuilder: (final double animationValue) {
              return dietTextCard(shortenedDietText);
            }
          ),
        ],
      );
    }
  );
}

// Used for builtDietInfo

Widget dietTextCard(final String shortenedDietText) {
  return libraryCard(
    shortenedDietText,
    TextFeatures.normal,
    alternate: false,
  );
}