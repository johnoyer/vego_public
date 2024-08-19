import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:flutter/material.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TreeNutFree extends PresetDiet {

  TreeNutFree()
      : super(
          name: 'Tree Nut-Free',
          dietInfo: 'Tree Nut free, does not include flours and other things',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          iconWidget: treeNutFreeIcon(),
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
        );

  static Widget treeNutFreeIcon() {
    return dietIconWrapper(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: SvgPicture.asset(
          'assets/tree_nut_icon.svg',
        ),
      ),
      true
    );
  }

  static List<String> prohibitedItemsList = [
    'Almonds',
    'American Chestnuts',
    'Beech nuts',
    'Brazil nuts',
    'Bush nuts',
    'Butternuts',
    'California walnuts',
    'Cashews',
    'Chestnuts',
    'Chinese Chestnuts', 
    'European Chestnuts',
    'Chinquapins',
    'Coconuts',
    'Cola nuts',
    'English walnuts',
    'Filberts',
    'Ginko nuts',
    'Hazelnuts',
    'Kola nuts',
    'Heartnuts',
    'Hickory nuts',
    'Japanese walnuts',
    'Macadamia nuts',
    'Palm nuts',
    'Pecans',
    'Persian walnuts',
    'Pine nut',
    'Pinon nuts',
    'Pili nuts',
    'Pistachios',
    'Shea nuts',
    'Seguin Chestnuts',
    'Sheanuts',
    'Walnuts'
  ];
  static List<String> possiblyProhibitedItemsList = [

  ];
}