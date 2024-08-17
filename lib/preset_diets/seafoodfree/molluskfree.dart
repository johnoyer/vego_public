import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MolluskFree extends PresetDiet {

  MolluskFree()
      : super(
          name: 'Mollusk-Free',
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
        padding: const EdgeInsets.all(3),
        child: SvgPicture.asset(
          'assets/mollusk_icon.svg',
          colorFilter: const ColorFilter.mode(
            Colors.brown,
            BlendMode.srcIn,
          ),
        ),
      ),
      true
    );
  }

  static List<String> prohibitedItemsList = [
    'Abalone',
    'Clam',
    'cherrystone clam', 
    'geoduck clam', 
    'littleneck clam', 
    'pismo clam', 
    'quahog clam',
    'surf clam',
    'Cockle',
    'Conch',
    'Cuttlefish',
    'Limpet',
    'lapas', 
    'Loco',
    'opihi',
    'Mollusks',
    'Mussels',
    'Nautilus',
    'Octopus',
    'Oysters',
    'Periwinkle',
    'Sea cucumber',
    'Sea urchin',
    'Scallop',
    'Bay Scallop',
    'Sea Scallop',
    'Snail',
    'escargot',
    'Squid',
    'calamari',
    'Whelk',
    'Turban shell'
  ];
    
  static List<String> possiblyProhibitedItemsList = [
    'Surimi',
    'Seafood flavoring',
    'Fish stock',
    'fish sauce',
    'Bouillabaisse',
    'Glucosamine'
  ];
}  