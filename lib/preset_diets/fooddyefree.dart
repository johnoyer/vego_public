import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:flutter/material.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodDyeFree extends PresetDiet {

  FoodDyeFree()
      : super(
          name: 'Food Dye-Free',
          dietInfo: 'Synthetic and semi-natural food dyes are prohibited in this diet, while natural food dyes '
      'are in the \'may be prohibited\' section. Both the FD&C (United States) and E Number (European '
      'Union) naming schemes are included, as well as other alternative names. Other regions '
      'may use different names and number schemes for food dye identification.',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          iconWidget: foodDyeFreeIcon(),
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
        );

  static Widget foodDyeFreeIcon() {
    return dietIconWrapper(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SvgPicture.asset(
          'assets/food_dye_icon.svg',
        ),
      ),
      true
    );
  }

  static List<String> prohibitedItemsList = [
    'Allura Red AC', 
    'Aluminium',
    'Ammonia caramel',
    'Artificial Color',
    'Artificial Colors',
    'Azorubine',
    'Amaranth', 
    'Beta-apo-8′-carotenal (C 30)',
    'Blue 1',
    'Blue 2',
    'Blue 5',
    'Brilliant Black PN',
    'Brilliant Blue FCF',
    'Brown HT',
    'Calcium carbonate',
    'Canthaxanthin',
    'Caramel Coloring',
    'Carmoisine',
    'Caustic sulphite caramel',
    'Citrus Red 2',
    'Erythrosine', 
    'E102',
    'E104',
    'E110',
    'E122',
    'E123',
    'E124',
    'E127',
    'E129',
    'E131',
    'E132',
    'E133',
    'E142',
    'E150a',
    'E150b',
    'E150c',
    'E150d',
    'E151',
    'E153',
    'E155',
    'E171',
    'E173',
    'E174',
    'E175',
    'E180',
    'Fast Green FCF', 
    'Gold',
    'Green S',
    'Green 3',
    'Indigo Carmine', 
    'Indigotine',
    'Litholrubine BK',
    'Orange Yellow S',
    'Patent Blue V', 
    'Plain caramel',
    'Ponceau 4R',
    'Quinoline Yellow',
    'Quinoline Yellow WS',
    'Quinoline Yellow SS',
    'Red 2',
    'Red 3',
    'Red 10',
    'Red 18',
    'Red 17',
    'Red 40',
    'Silver',
    'Sulphite ammonia caramel',
    'Sunset Yellow FCF', 
    'Tartrazine',
    'Titanium dioxide',
    'Yellow 5',
    'Yellow 6',
    'Yellow 10',
    'Yellow 13'
  ];

  static List<String> possiblyProhibitedItemsList = [
    'E100',
    'E101',
    'E120',
    'E140',
    'E141',
    'E160a',
    'E160b(i)',
    'E160b(ii)',
    'E160c',
    'E160d',
    'E160e',
    'E161b',
    'E161g',
    'E162',
    'E163',
    'E170',
    'E172',
    'Annatto',
    'Annatto bixin',
    'Annatto norbixin',
    'Anthocyanins',
    'Beetroot Red',
    'betanin',
    'Carmine', 
    'Carminic acid',
    'Carotenes',
    'Chlorophyllins',
    'Chlorophylls',
    'Cochineal Red A',
    'Copper complexes of chlorophyllins',
    'Copper complexes of chlorophylls',
    'Curcumin',
    'Elderberry Juice',
    'Iron oxides and hydroxides',
    'Lutein',
    'Lycopene',
    'Natural Red 4',
    'Paprika',
    'Paprika extract',
    'capsanthin',
    'capsorubin',
    'Riboflavins',
    'Turmeric',
    'Vegetable carbon'
  ];
}