import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter/material.dart';


Widget saveDietCard (final double animationValue) {
  return libraryCard(
    'Save Diet', 
    TextFeatures.normal, 
    alternate: false,
    icon: Icons.save,
    iconColor: Colors.blue,
    animationValue: animationValue
  );
}

Widget removeDietCard (final double animationValue) {
  return libraryCard(
    'Delete Diet', 
    TextFeatures.normal, 
    alternate: false,
    icon: Icons.delete,
    iconColor: Colors.red,
    animationValue: animationValue
  );
}

