import 'package:flutter/material.dart';
import 'package:vego_flutter_project/global_widgets.dart';


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