import 'package:flutter/material.dart';
import 'package:vego_flutter_project/global_widgets/global_widgets.dart';

const String info = 'This ingredient list scanner lets you take a picture of an ingredient list to determine '
  'whether it is compatible with your diet. Take a picture by tapping the camera icon, '
  'ensuring that all ingredients are fully within the frame.\n\nOnce the list has been '
  'successfully scanned, you may swap between viewing the image taken and visualizing the '
  'list of ingredients in text format. Make sure that the ingredients have been correctly '
  'scanned and that no ingredients are missing or have been incorrectly read.\n\nYou may '
  'edit the scanned list of ingredients in case there are any errors, or if you want to '
  'remove some ingredients or add some of your own!';

Widget swapViewingModeCard() {
  return libraryCard(
    'Swap Viewing Mode',
    TextFeatures.small,
    alternate: false,
    icon: Icons.visibility
  );
}

Widget editIngredientInformationCard() {
  return libraryCard(
    'Edit Ingredient Information',
    TextFeatures.small,
    alternate: false,
    icon: Icons.edit,
  );
}