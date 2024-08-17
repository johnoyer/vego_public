import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoeFree extends PresetDiet {

  RoeFree()
      : super(
          name: 'Roe-Free',
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
        padding: const EdgeInsets.only(bottom: 3),
        child: SvgPicture.asset(
          'assets/roe_icon.svg',
          colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 255, 72, 0),
            BlendMode.srcIn,
          ),
        ),
      ),
      true
    );
  }

  static List<String> prohibitedItemsList = [
    'Caviar',
    'sturgeon roe', 
    'Ikura',
    'salmon roe',
    'Kazunoko', 
    'herring roe',
    'Lumpfish roe',
    'Masago', 
    'capelin roe',
    'Shad roe',
    'Tobiko',
    'flying-fish roe',
    'Uni',
    'Sea Urchin roe'
  ];
    
  static List<String> possiblyProhibitedItemsList = [

  ];
}  