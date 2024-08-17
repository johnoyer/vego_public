import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CrustaceanShellfishFree extends PresetDiet {

  CrustaceanShellfishFree()
      : super(
          name: 'Crustacean Shellfish-Free',
          dietInfo: 'TODO',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          primaryItems: prohibitedItemsList,
          iconWidget: seaFoodFreeIcon(),
          secondaryItems: possiblyProhibitedItemsList,
        );

  static Widget seaFoodFreeIcon() {
    return dietIconWrapper(
      Padding(
        padding: const EdgeInsets.only(top: 3, left: 4, right: 3, bottom: 3),
        child: SvgPicture.asset(
          'assets/crustacean_shellfish_icon.svg',
          colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 232, 64, 120),
            BlendMode.srcIn,
          ),
        ),
      ),
      true
    );
  }

  static List<String> prohibitedItemsList = [
    'Barnacle', 
    'Crab',
    'Crawfish',
    'crawdad',
    'crayfish',
    'ecrevisse',
    'Krill',
    'Lobster',
    'langouste',
    'langoustine', 
    'Moreton bay bugs', 
    'tomalley',
    'Prawns',
    'Shrimp',
    'Shrimp scampi',
    'scampi',
    'Shrimp crevette',
    'crevette'
  ];
    
  static List<String> possiblyProhibitedItemsList = [
    'Cuttlefish ink',
    'Surimi',
    'Seafood flavoring',
    'Fish stock',
    'fish sauce',
    'Bouillabaisse',
    'Glucosamine'
  ];
}  