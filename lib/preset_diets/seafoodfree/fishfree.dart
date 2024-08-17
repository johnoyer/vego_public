import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FishFree extends PresetDiet {

  FishFree()
      : super(
          name: 'Fish-Free',
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
        padding: const EdgeInsets.only(left: 2, right: 1),
        child: SvgPicture.asset(
          'assets/fish_icon.svg',
          colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 123, 129, 141),
            BlendMode.srcIn,
          ),
        ),
      ),
      true
    );
  }

  static List<String> prohibitedItemsList = [
    'Anchovies',
    'Anglerfish',
    'Barracuda',
    'Basa',
    'Bass',
    'striped bass',
    'Black cod',
    'Bluefish',
    'Bombay duck',
    'Bonito',
    'Bream',
    'Brill',
    'Burbot',
    'Catfish',
    'Cod',
    'Pacific cod',
    'Atlantic cod',
    'Dogfish',
    'Dorade',
    'Eel',
    'Fish',
    'Flounder',
    'Grouper',
    'Haddock',
    'Hake',
    'Halibut',
    'Herring',
    'Ilish',
    'John Dory',
    'Lamprey',
    'Lingcod',
    'Common ling',
    'Mackerel',
    'Horse mackerel',
    'Mahi Mahi',
    'Monkfish',
    'Mullet',
    'Orange roughy',
    'Pacific rudderfish',
    'Japanese butterfish',
    'Pacific saury',
    'Parrotfish',
    'Patagonian toothfish',
    'Chilean sea bass',
    'Perch',
    'Pike',
    'Pollock',
    'Pomfret',
    'Pompano',
    'Pufferfish',
    'Fugu',
    'Sablefish',
    'Sanddab',
    'Pacific sanddab',
    'Sardine',
    'Sea bass',
    'Sea bream',
    'Shad',
    'alewife',
    'American shad',
    'Shark',
    'Skate',
    'Smelt',
    'Snakehead',
    'Snapper',
    'rockfish',
    'rock cod',
    'Pacific snapper',
    'Sole',
    'Sprat',
    'Stromateidae',
    'butterfish',
    'Sturgeon',
    'Surimi',
    'Swordfish',
    'Tilapia',
    'Tilefish',
    'Trout',
    'rainbow trout',
    'Tuna',
    'albacore tuna',
    'yellowfin tuna',
    'bigeye tuna',
    'bluefin tuna',
    'dogtooth tuna',
    'Turbot',
    'Wahoo',
    'Whitefish',
    'stockfish',
    'Whiting',
    'Witch',
    'righteye flounder',
    'Yellowtail',
    'Japanese amberjack',
  ];
    
  static List<String> possiblyProhibitedItemsList = [

  ];
}  