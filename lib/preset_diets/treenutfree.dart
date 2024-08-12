import 'package:vego_flutter_project/diet_classes/diet_class.dart';

class TreeNutFree extends PresetDiet {

  TreeNutFree()
      : super(
          name: 'Tree Nut-Free',
          dietInfo: 'Tree Nut free, does not include flours and other things',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
        );

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