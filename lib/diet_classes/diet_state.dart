import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_attributes.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/preset_diets/preset_diets_container.dart';


class DietState extends ChangeNotifier {
  static final DietState _singleton = DietState._internal();

  factory DietState() {
    return _singleton;
  }

  DietState._internal();

  // Diet attributes manager
  static DietAttributesManager dietAttributesManager = DietAttributesManager();

  static const int maxDiets = 30;

  // ingredientInfo, status, _numberSelected and _selectedIndex
  static IngredientInfo? _ingredientInfo;
  static Status _status = Status.none;
  static int _numberSelected = 0; // will be changed upon initialization
  static int _selectedIndex = 0;

  // Settings variables
  // static Map<String, bool>
  static bool dietCreationAnimations = true;
  static bool slowAnimations = true;
  static bool slowIngredientAnimations = true;
  static bool persistentIngredients = true;
  static bool spellCheck = true;

  // shared preferences
  static SharedPreferences? _preferences;

  // diets
  static List<Diet> _diets = [
    Vegan(),
    Vegetarian(),
    GlutenFree(),
    FoodDyeFree(),
    AdditiveFree(),
    TreeNutFree(),
    SeaFoodFree(),
  ];

  static List<Diet> getDietList() {
    return _diets;
  }

  // ingredientInfo, status, _numberSelected and _selectedIndex
  int getNumberSelected() => _numberSelected;

  void updateNumberSelected() {
    _numberSelected = (_diets.where((final diet) => diet.isChecked).toList()).length;
    notifyListeners();
  }

  int getSelectedIndex() => _selectedIndex;

  void updateSelectedIndex(final int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }

  Status getStatus() => _status;

  void setStatus(final Status newStatus) {  
    _status = newStatus;
    notifyListeners();
  }

  IngredientInfo? getIngredientInfo() => _ingredientInfo;

  void clearIngredientInfo() {
    _ingredientInfo = null;
    _status = Status.none;
    notifyListeners();
  }

  void setIngredients(final List<String>? persistentIngredientsList) {
    _ingredientInfo ??= IngredientInfo();
    if(persistentIngredientsList!=null) {
      _ingredientInfo!.persistentIngredientsList = persistentIngredientsList;
    }
    notifyListeners();
  }

  // Shared preferences functions

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    final String? dietsJson = _preferences?.getString('diets');
    dietCreationAnimations = _preferences?.getBool('dietCreationAnimations') ?? true;
    slowAnimations = _preferences?.getBool('slowAnimations') ?? true;
    slowIngredientAnimations = _preferences?.getBool('slowIngredientAnimations') ?? true;
    persistentIngredients = _preferences?.getBool('persistentIngredients') ?? true;
    spellCheck = _preferences?.getBool('spellCheck') ?? true;
    if (dietsJson != null) { // if there is an instance of sharedpreferences. if not values for diets will go to default
      try {
        final List<dynamic> decodedList = json.decode(dietsJson);
        final List<Diet> newDiets = decodedList.map((final json) {
          return Diet.fromJson(json);
        }).toList();
        _diets = newDiets;
      } catch (e) {
        print('Exception in initialize: $e');
      }
    } else {
      for(Diet diet in _diets) {
        diet.isChecked = false;
        diet.hidden = false;
      }
    }
    for(int i=0; i<_diets.length; i++) {
      _sortItems(i);
    }
    _numberSelected = (_diets.where((final diet) => diet.isChecked).toList()).length;
  }

  static void _sortItems(final int dietIndex) {
    _diets[dietIndex].primaryItems.sort();
    _diets[dietIndex].secondaryItems.sort();
  }

  static Future<void> _saveDietsAndSettings() async {
    if(_preferences==null) throw Exception('unitialized preferences');
    await _preferences!.setString('diets', json.encode(_diets));
    await _preferences!.setBool('dietCreationAnimations', dietCreationAnimations);
    await _preferences!.setBool('slowAnimations', slowAnimations);
    await _preferences!.setBool('slowIngredientAnimations', slowIngredientAnimations);
    await _preferences!.setBool('persistentIngredients', persistentIngredients);
    await _preferences!.setBool('spellCheck', spellCheck); 
  }

  // Diet editing functions

  void setIsChecked(final int index, final bool isChecked) => _diets[index].isChecked = isChecked;

  void setIsHidden(final int index, final bool hidden) => _diets[index].hidden = hidden;
  
  Future<void> toggleIsChecked(final int index) async {
    _diets[index].isChecked = !_diets[index].isChecked;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> toggleHidden(final int index) async {
    _diets[index].hidden = !_diets[index].hidden;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> updateIsProhibitive(final int index, final bool newValue) async {
    _diets[index].isProhibitive = newValue;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<bool?> updateDietName(final int index, final String newName) async {
    if(newName=='') {
      return false;
    }
    if(_diets.map((final diet) => diet.name).toList().contains(newName)&&newName!=_diets[index].name) {
      return true;
    }
    _diets[index].name = newName;
    notifyListeners();
    await _saveDietsAndSettings();
    return null;
  }

  Future<void> updateDietInfo(final int index, final String dietInfo) async {
    _diets[index].dietInfo = dietInfo;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> updateDietItems(final int index, final List<String> newItems, final bool primary) async {
    if(primary) { 
      _diets[index].primaryItems = newItems;
    } else { 
      _diets[index].secondaryItems = newItems;
    }
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> addDietItemsAll(final int index, final List<String> items, final bool primary) async {
    final Set<String> ingredientsSetFormat = lowerCaseEveryWord(items).toSet();
    final Set<String> itemsSet = lowerCaseEveryWord(_diets[index].primaryItems).toSet();
    final Set<String> secondaryItemsSet = lowerCaseEveryWord(_diets[index].secondaryItems).toSet();
    if(primary) {
      itemsSet.addAll(ingredientsSetFormat);
      secondaryItemsSet.removeAll(ingredientsSetFormat);
    } else {
      ingredientsSetFormat.removeAll(itemsSet);
      secondaryItemsSet.addAll(ingredientsSetFormat);
    }
    _diets[index].primaryItems = itemsSet.toList();
    _diets[index].secondaryItems = secondaryItemsSet.toList();
    _diets[index].primaryItems.sort();
    _diets[index].secondaryItems.sort();
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> addDietItemsFromDiet(final int index, final PresetDiet diet, final List<bool>? indices) async {
    final Set<String> primaryItemsInitialSet = lowerCaseEveryWord(_diets[index].primaryItems).toSet();
    final Set<String> secondaryItemsInitialSet = lowerCaseEveryWord(_diets[index].secondaryItems).toSet();
    Set<String> primaryItemsToAddSet = {};
    Set<String> secondaryItemsToAddSet = {};
    if(indices!=null && diet is! PresetDietWithSubdiets) { // PresetDiet some selected (only primary items will be present)
      assert(diet.secondaryItems.isEmpty); // Confirm that secondaryItems is empty
      assert(indices.length==diet.primaryItems.length);
      for (int i = 0; i < indices.length; i++) {
        if (indices[i]) {
          if(!lowerCaseEveryWord(_diets[index].primaryItems).contains(diet.primaryItems[i].toLowerCase())) {
            primaryItemsToAddSet.add(diet.primaryItems[i].toLowerCase());
          }
        }
      }
    } else if (indices!=null) { // PresetDietWithSubDiets some selected
      for(int i=0; i<indices.length; i++) {
        if(indices[i]) { // TODO: test
          final List<String> primaryItems = (diet as PresetDietWithSubdiets).subDiets[i].primaryItems;
          primaryItemsToAddSet.addAll(primaryItems);
          final List<String> secondaryItems = diet.subDiets[i].secondaryItems;
          secondaryItemsToAddSet.addAll(secondaryItems);
        }
      }
    } else { // Normal PresetDiet
      primaryItemsToAddSet = lowerCaseEveryWord(diet.primaryItems).toSet();
      secondaryItemsToAddSet = lowerCaseEveryWord(diet.secondaryItems).toSet();
    }
    primaryItemsInitialSet.addAll(primaryItemsToAddSet);
    secondaryItemsInitialSet.removeAll(primaryItemsToAddSet);
    secondaryItemsToAddSet.removeAll(primaryItemsInitialSet);
    secondaryItemsInitialSet.addAll(secondaryItemsToAddSet);
    _diets[index].primaryItems = primaryItemsInitialSet.toList();
    _diets[index].primaryItems.sort();
    _diets[index].secondaryItems = secondaryItemsInitialSet.toList();
    _diets[index].secondaryItems.sort();
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<bool?> addDiet() async {
    final CustomDiet diet = CustomDiet();
    if (_diets.any((final diet) => diet.name=='')) {
      return false;
    } else if (_diets.length>=maxDiets) { // >= is a safeguard, _diets.length should never exceed maxDiets
      return true;
    } else {
      _diets.add(diet);
      notifyListeners();
      await _saveDietsAndSettings();
      return null;
    }
  }

  Future<void> removeDiet(final int index) async {
    if(_diets[index] is CustomDiet && index < _diets.length) {
      _diets.removeAt(index);
      updateNumberSelected(); // Check how many are selected, accounting for the diet being removed
      notifyListeners();
      await _saveDietsAndSettings();
    } else if(index>=_diets.length) {
      throw RangeError;
    } else {
      throw Error;
    }
  }

  // Settings functions

  Future<void> toggleDietCreationAnimations() async {
    dietCreationAnimations = !dietCreationAnimations;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> toggleSlowAnimations() async {
    slowAnimations = !slowAnimations;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> toggleSlowIngredientAnimations() async {
    slowIngredientAnimations = !slowIngredientAnimations;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> togglePersistentIngredients() async {
    persistentIngredients = !persistentIngredients;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> toggleSpellCheck() async {
    spellCheck = !spellCheck;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> resetSettings() async {
    dietCreationAnimations = true;
    slowAnimations = true;
    slowIngredientAnimations = true;
    persistentIngredients = true; 
    spellCheck = true;
    notifyListeners();
    await _saveDietsAndSettings();
  }

  Future<void> reset() async { // Reset all diet information
    try {
      if(_preferences!=null) {
        await _preferences!.clear(); // Clear all stored data
      }
      _diets.removeWhere((final diet) => diet.isCustom());
      await initialize(); // initialize again
      updateNumberSelected();
      notifyListeners();
    } catch (e) {
      print('Error during reset: $e');
    }
  }

  // Helper Functions 

  static Future<void> loadDietData() async { // Combine all of the ingredients for all the checked diets into lists
    final List<String> nonConformingIngredientsCompleteList = [];
    final List<String> canBeConformingIngredientsCompleteList = [];
    final List<String> conformingIngredientsCompleteList = [];
    bool isProhibiting = false;
    bool isAllowing = false;
    for (Diet diet in DietState._diets) {
      if(diet.isChecked) {
        if(diet.isProhibitive) {
          nonConformingIngredientsCompleteList.addAll(lowerCaseEveryWord(diet.primaryItems));
          isProhibiting = true;
        } else {
          conformingIngredientsCompleteList.addAll(lowerCaseEveryWord(diet.primaryItems));
          isAllowing = true;
        }
        canBeConformingIngredientsCompleteList.addAll(diet.secondaryItems);
      }
    }
    _ingredientInfo = IngredientInfo(); // _ingredientInfo must be reInitialized
    _ingredientInfo!.canBeConformingIngredientsCompleteList = canBeConformingIngredientsCompleteList;
    if(isProhibiting) {
      _ingredientInfo!.nonConformingIngredientsCompleteList = nonConformingIngredientsCompleteList;
    }
    if(isAllowing) {
      _ingredientInfo!.conformingIngredientsCompleteList = conformingIngredientsCompleteList;
    }
  }
}

class IngredientInfo {
  List<String>? canBeConformingIngredientsCompleteList;
  List<String>? nonConformingIngredientsCompleteList;
  List<String>? conformingIngredientsCompleteList;
  List<String>? persistentIngredientsList;
}