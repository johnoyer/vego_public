import 'package:vego_flutter_project/diet_classes/diet_state.dart';
export 'package:vego_flutter_project/library/textstyles.dart';
export 'package:vego_flutter_project/library/constants.dart';
export 'package:vego_flutter_project/library/structural_elements.dart';
export 'package:vego_flutter_project/library/messages.dart';

// String processing functions

bool isRedWord(final String word) {
  if(DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList==null) {
    throw StateError('canBeConformingIngredientsCompleteList has not been established');
  } else if(DietState().getIngredientInfo()!.nonConformingIngredientsCompleteList==null
    && DietState().getIngredientInfo()!.conformingIngredientsCompleteList==null) {
    throw StateError('neither nonConformingIngredientsCompleteList nor conformingIngredientsCompleteList has been established');
  }
  final bool inCanBeConformingList = DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList
      !.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase());
  final bool inNonConformingList = DietState().getIngredientInfo()!.nonConformingIngredientsCompleteList
      ?.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase()) ?? false;
  final bool inConformingList = DietState().getIngredientInfo()!.conformingIngredientsCompleteList
      ?.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase()) ?? true;
  // Returns true if the ingredient is nonconforming, or it is not conforming and not possibly conforming
  return inNonConformingList || (!inConformingList&&!inCanBeConformingList);
}

bool isOrangeWord(final String word) {
  if(DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList==null) {
    throw StateError('canBeConformingIngredientsCompleteList has not been established');
  }
  final bool inCanBeConformingList = DietState().getIngredientInfo()!.canBeConformingIngredientsCompleteList
      !.any((final ingredient) => ingredient.toLowerCase() == word.toLowerCase());
  // Returns true if the ingredient can be conforming
  return inCanBeConformingList;
}

String removePrefixes(String ingredient) {
  final RegExp removePatterns = RegExp(r'\b(?:atlantic|concentrated|dehydrated|dried|emulsifier|enriched|extract|expeller pressed|for freshness|for quality|freeze-dried|fresh|fried|ground|juice|isolate|lake|minced|malted|melted|organic|pacific|pitted|powdered|preserved|pressed|processed|reduced|roasted|salted|stock|unbleached|)\b', caseSensitive: false);
  ingredient = ingredient.replaceAll(',',''); // Remove commas
  ingredient = ingredient.replaceAll('(',''); // Remove parenthesis 
  ingredient = ingredient.replaceAll(')',''); // Remove parenthesis
  ingredient = ingredient.replaceAll('*',''); // Remove asterisks
  ingredient = ingredient.replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
  return ingredient.replaceAll(removePatterns, '').trim();
}

String capitalizeFirstLetter(final String input) {
  return input.split(' ').map((final word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

List<String> capitalizeFirstLetterOfEveryWord(final List<String> inputList) {
  return inputList.map((final str) => capitalizeFirstLetter(str)).toList();
}

List<String> lowerCaseEveryWord(final List<String> inputList) {
  return inputList.map((final str) => str.toLowerCase().trim()).toList();
}
