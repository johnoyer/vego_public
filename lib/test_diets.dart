import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:flutter/material.dart';

class TestDiet1 extends PresetDiet {

  TestDiet1()
      : super(
          name: 'TestDiet1',
          dietInfo: '',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          iconWidget: Container(),
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
        );

  static const List<String> prohibitedItemsList = [
    '1primarya',
    '1primaryb',
    '1primaryc',
    '1primaryd'
  ];

  static const List<String> possiblyProhibitedItemsList = [
    '1secondarya',
    '1secondaryb',
    '1secondaryc',
    '1secondaryd'
  ];
}

class TestDiet2 extends PresetDiet {

  TestDiet2()
      : super(
          name: 'TestDiet2',
          dietInfo: '',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          iconWidget: Container(),
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
        );

  static const List<String> prohibitedItemsList = [
    '1primarya',
    '1secondarya',
    '2primarya',
    '2primaryb',
    '2primaryc',
    '2primaryd'
  ];

  static const List<String> possiblyProhibitedItemsList = [
    '1primaryb',
    '1secondaryb',
    '2secondarya',
    '2secondaryb',
    '2secondaryc',
    '2secondaryd'
  ];
}

class TestDiet3 extends PresetDiet {

  TestDiet3()
      : super(
          name: 'TestDiet3',
          dietInfo: '',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          iconWidget: Container(),
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
        );

  static const List<String> prohibitedItemsList = [
    '1primarya', // only in primaryList, from primary
    'a',
    '1primaryb', // in both lists, from primary
    '1secondaryb', // only in primaryList, from secondary
    '1secondaryc', // in both lists, from secondary
    'b',
    '3primarya', // only in primaryList, new
    '3primaryb', // in both lists, new
    'c'
  ];

  static const List<String> possiblyProhibitedItemsList = [
    // '1primaryb', // in both lists, from primary
    // '1primaryc', // only in secondaryList, from primary
    // '1secondaryc', // in both lists, from secondary
    // '1secondaryd', // only in secondaryList, from secondary
    // '3primaryb', // in both lists, new
    // '3secondarya' // only in secondaryList, new
  ];
}

class TestDiet4 extends PresetDietWithSubdiets {

  TestDiet4()
      : super(
          name: 'TestDiet4',
          dietInfo: '',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          iconWidget: Container(),
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
          primarySubDietNameToListMap: primarySubDietNameToListMapLocal,
          secondarySubDietNameToListMap: secondarySubDietNameToListMapLocal,
          subDietIconsMap: {}
        );

  static const List<String> prohibitedItemsList = [];

  static const List<String> possiblyProhibitedItemsList = [];

    static const Map<String,List<String>> primarySubDietNameToListMapLocal = {//need to change all below todo
    'a': ['axxx'],
    'b': [
      '1primarya', // only in primaryList, from primary
      '1primaryb', // in both lists, from primary
      '1secondaryd', // only in primaryList, from secondary
    ],
    'c': ['cxxx'],
    'd': [
      '2secondarya', // in both lists, from secondary
      '4primarya', // only in primaryList, new
      '4primaryb', // in both lists, new
    ],
    'e': ['exxx'],
  };

  static const Map<String,List<String>> secondarySubDietNameToListMapLocal = {
    'a': ['ayyy'],
    'b': [
      '1primaryb', // in both lists, from primary
      '1primaryc', // only in secondaryList, from primary
      '2secondarya', // in both lists, from secondary
    ],
    'c': ['cyyy'],
    'd': [
      '2secondaryb', // only in secondaryList, from secondary
      '4primaryb', // in both lists, new
      '4secondarya' // only in secondaryList, new
    ],
    'e': ['eyyy'],
  };
}
