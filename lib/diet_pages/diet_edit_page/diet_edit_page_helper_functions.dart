import 'package:vego_flutter_project/global_widgets.dart';
import 'package:flutter/material.dart';


Widget saveDietCard () {
  return libraryCard(
    'Save Diet', 
    TextFeatures.normal, 
    alternate: false,
    icon: Icons.save,
    iconColor: Colors.blue,
  );
}

Widget removeDietCard () {
  return libraryCard(
    'Delete Diet', 
    TextFeatures.normal, 
    alternate: false,
    icon: Icons.delete,
    iconColor: Colors.red,
  );
}

