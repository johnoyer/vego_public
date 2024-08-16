import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:flutter/material.dart';

class GlutenFree extends PresetDiet {

  GlutenFree()
      : super(
          name: 'Gluten-Free',
          dietInfo: '(From Wikipedia) A gluten-free diet (GFD) is a nutritional plan '
          'that strictly excludes gluten, which is a mixture of prolamin proteins '
          'found in wheat (and all of its species and hybrids, such as spelt, kamut, '
          'and triticale), as well as barley, rye, and oats. The inclusion of oats '
          'in a gluten-free diet remains depends on the oat '
          'cultivar and the frequent cross-contamination with other gluten-containing '
          'cereals.',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          iconWidget: glutenFreeIcon(),
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
        );

  static Widget glutenFreeIcon() {
    return const Icon(
      Icons.grass,
      color: Colors.white,
    );
  }

  static List<String> prohibitedItemsList = [
    'atta flour',
    'barley', 
    'barley flakes', 
    'barley flour', 
    'barley pearl', 
    'bread flour',
    'breading', 
    'bread stuffing', 
    "brewer's yeast", 
    'bulgur', 
    'cake flour',
    'couscous',
    'dinkel',
    'durum', 
    'einkorn',
    'emmer',
    'farro', 
    'faro',
    'fu',
    'graham flour', 
    'gluten',
    'gluten flour',
    'hydrolyzed wheat protein', 
    'kamut', 
    'malt', 
    'malt extract', 
    'malt syrup', 
    'malt flavoring', 
    'malt vinegar', 
    'malted milk', 
    'matzo', 
    'matzo meal', 
    'modified wheat starch', 
    'oat bran', 
    'oat flour', 
    'oatmeal', 
    'rye bread and flour', 
    'seitan', 
    'semolina', 
    'spelt', 
    'triticale', 
    'wheat',
    'wheat berries',
    'wheat bran', 
    'wheat flour', 
    'wheat germ', 
    'wheat protein',
    'wheat starch'
  ];
  static List<String> possiblyProhibitedItemsList = [
    'autolyzed yeast extract',
    'blue cheese',
    'dextrin',
    'flavored vinegar',
    'flour',
    'modified food starch',
    'rice syrup',
    'smoke flavoring',
    'starch',
    'whole oats',
    'yeast extract'
  ];
}