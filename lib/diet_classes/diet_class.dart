import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:flutter/material.dart';

abstract class Diet {
  String name;
  String dietInfo;
  bool isProhibitive;
  bool isChecked;
  bool hidden;
  List<String> primaryItems;
  List<String> secondaryItems;
  
  Diet({
    this.name = '', 
    this.dietInfo = '',
    this.isProhibitive = false, 
    this.isChecked = false,
    this.hidden = false,
    final List<String>? primaryItems, 
    final List<String>? secondaryItems,
  }) : primaryItems = primaryItems ?? [],  // Initialize items with an empty list if null
       secondaryItems = secondaryItems ?? [];  // Initialize secondaryItems with an empty list if null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dietInfo': dietInfo,
      'isProhibitive': isProhibitive,
      'isChecked': isChecked,
      'hidden': hidden,
      'primaryItems': primaryItems,
      'secondaryItems': secondaryItems,
      'isCustom': false,
    };
  }

  factory Diet.fromJson(final Map<String, dynamic> json) {
    if (json['isCustom'] == true) {
      return CustomDiet(
        name: json['name'],
        dietInfo: json['dietInfo'],
        isProhibitive: json['isProhibitive'],
        isChecked: json['isChecked'],
        hidden: json['hidden'],
        primaryItems: List<String>.from(json['primaryItems'] ?? []),
        secondaryItems: List<String>.from(json['secondaryItems'] ?? []),
      );
    } else {
      final int dietIndex = DietState.getDietList().indexWhere((final diet) => diet.name == json['name']);
      DietState().setIsChecked(dietIndex, json['isChecked']);
      DietState().setIsHidden(dietIndex, json['hidden']);
      return DietState.getDietList()[dietIndex];
    }
  }

  bool isCustom() {
    return (this is CustomDiet);
  }

  bool isPresetDietWithSubDiets() {
    return (this is PresetDietWithSubdiets);
  }
}

class PresetDiet extends Diet {
  Widget iconWidget;

  PresetDiet({
    super.name,
    super.dietInfo,
    super.isProhibitive,
    super.hidden,
    super.isChecked,
    super.primaryItems,
    super.secondaryItems,
    required this.iconWidget,
  });
}

class CustomDiet extends Diet {
  CustomDiet({
    super.name,
    super.dietInfo,
    super.isProhibitive,
    super.hidden,
    super.isChecked,
    super.primaryItems,
    super.secondaryItems,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['isCustom'] = true; // Add a flag for custom diet
    return json;
  }
}


class PresetDietWithSubdiets extends PresetDiet {
  PresetDietWithSubdiets({
    super.name,
    super.dietInfo,
    super.isProhibitive,
    super.hidden,
    super.isChecked,
    super.primaryItems,
    super.secondaryItems,
    required super.iconWidget,
    required this.primarySubDietNameToListMap,
    required this.secondarySubDietNameToListMap,
    required this.subDietIconsMap,
  });

  Map<String, List<String>> primarySubDietNameToListMap;
  Map<String, List<String>> secondarySubDietNameToListMap;
  Map<String, Icon> subDietIconsMap;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['hasSubdiets'] = true; // Add a flag for containing subdiets
    return json;
  }
}