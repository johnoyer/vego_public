// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_classes/diet_attributes.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/test_diets.dart';
import 'package:vego_flutter_project/ingredient_recognition/ingredient_processing_functions.dart';

void main() {
  group('All Tests', () {  
    group('Test DietState', () {
      void assertInitialDietState() {
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, true);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, true);
        expect(DietState.getDietList().length, 7);
        expect(DietState().getNumberSelected(), 0);
        expect(DietState().getStatus(), Status.none);
        expect(DietState().getIngredientInfo(), null);

        expect(DietState.dietAttributesManager.dietAttributes.length, 7);
        for(DietAttributeContainer dietAttributeContainer in DietState.dietAttributesManager.dietAttributes) {
          expect(dietAttributeContainer.diet.isChecked, false);
          expect(dietAttributeContainer.diet.isProhibitive, true);
          expect(dietAttributeContainer.diet.hidden, false);
          expect(dietAttributeContainer.diet.isCustom(), false);
        }
      }

      Future<void> initialize() async {
        WidgetsFlutterBinding.ensureInitialized();
        SharedPreferences.setMockInitialValues({}); //todo: check this
        await DietState().reset();
        await DietState.initialize();
        assertInitialDietState();
      }

      void assertDietsCorrectlyAdded() {
        expect(DietState.getDietList().last.primaryItems.toSet(),{
          // From TestDiet1
          '1primarya',
          '1primaryb',
          '1primaryc',
          '1primaryd',
          // From TestDiet2
          '1secondarya',
          '2primarya',
          '2primaryb',
          '2primaryc',
          '2primaryd',
          // From primary list/TestDiet3
          '1secondaryb',
          '1secondaryc',
          '3primarya',
          '3primaryb',
          // From TestDiet4
          '1secondaryd',
          '2secondarya',
          '4primarya',
          '4primaryb',
        });
        expect(DietState.getDietList().last.secondaryItems.toSet(),{
          // From TestDiet1
          // From TestDiet2
          '2secondaryb',
          '2secondaryc',
          '2secondaryd',
          // From secondary list
          '3secondarya',
          // From TestDiet4
          '4secondarya',
        });
      }
      
      Future<void> addingOperation1() async {
        await DietState().addDietItemsFromDiet(DietState.getDietList().length-1, TestDiet1(), null);
      }
      Future<void> addingOperation2() async {
        await DietState().addDietItemsFromDiet(DietState.getDietList().length-1, TestDiet2(), null);
      }
      Future<void> addingOperation3() async {
        // await DietState().addDietItemsAll(DietState.getDietList().length-1, [
        //   '1primarya', // only in primaryList, from primary
        //   '1primaryb', // in both lists, from primary
        //   '1secondaryb', // only in primaryList, from secondary
        //   '1secondaryc', // in both lists, from secondary
        //   '3primarya', // only in primaryList, new
        //   '3primaryb' // in both lists, new
        // ], true);
        // above is same as below
        await DietState().addDietItemsFromDiet(DietState.getDietList().length-1, TestDiet3(), [
          true,
          false,
          true,
          true,
          true,
          false,
          true,
          true,
          false        
        ]);
        await DietState().addDietItemsAll(DietState.getDietList().length-1, [
          '1primaryb', // in both lists, from primary
          '1primaryc', // only in secondaryList, from primary
          '1secondaryc', // in both lists, from secondary
          '1secondaryd', // only in secondaryList, from secondary
          '3primaryb', // in both lists, new
          '3secondarya' // only in secondaryList, new
        ], false);
      }
      Future<void> addingOperation4() async {
        await DietState().addDietItemsFromDiet(DietState.getDietList().length-1, TestDiet4(), [false, true, false, true, false]);
      }
      test('Testing whether DietState has correctly initialized values', () async {
        await initialize();

        // Call to reset()
        DietState().reset();
        assertInitialDietState();

        // Call to resetSettings()
        DietState().resetSettings();
        assertInitialDietState();

        // More calls to functions in different order ensuring that every function is called directly after every other at some point
        await DietState.initialize();
        assertInitialDietState();

        DietState().resetSettings();
        assertInitialDietState();

        DietState().reset();
        assertInitialDietState();

        await DietState.initialize();
        assertInitialDietState();
      });
      
      test('Testing DietState settings functions', () async {
        await initialize();

        // Testing toggle functions
        DietState().toggleDietCreationAnimations();
        expect(DietState.dietCreationAnimations, false);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, true);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, true);
        DietState().toggleDietCreationAnimations();
        assertInitialDietState();

        DietState().toggleSlowAnimations();
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, false);
        expect(DietState.slowIngredientAnimations, true);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, true);
        DietState().toggleSlowAnimations();
        assertInitialDietState();

        DietState().toggleSlowIngredientAnimations();
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, false);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, true);
        DietState().toggleSlowIngredientAnimations();
        assertInitialDietState();

        DietState().togglePersistentIngredients();
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, true);
        expect(DietState.persistentIngredients, false);
        expect(DietState.spellCheck, true);
        DietState().togglePersistentIngredients();
        assertInitialDietState();
        
        DietState().toggleSpellCheck();
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, true);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, false);
        DietState().toggleSpellCheck();
        assertInitialDietState();

        // Testing DietState().resetSettings
        DietState().toggleSlowIngredientAnimations();
        DietState().toggleSpellCheck();
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, false);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, false);
        DietState().resetSettings();
        assertInitialDietState();

        // Testing DietState().reset
        DietState().toggleSlowIngredientAnimations();
        DietState().toggleSpellCheck();
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, false);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, false);
        await DietState().reset();
        assertInitialDietState();


        // // Testing DietState().initialize
        // DietState().toggleSlowIngredientAnimations();
        // DietState().toggleSpellCheck();
        // expect(DietState.dietCreationAnimations, true);
        // expect(DietState.slowAnimations, true);
        // expect(DietState.slowIngredientAnimations, false);
        // expect(DietState.persistentIngredients, true);
        // expect(DietState.spellCheck, false);
        // await DietState().initialize();
        // assertInitialDietState();

        // Checking preservation of settings after DietState().initialize (after app as a whole is reset)
        await DietState().toggleSlowIngredientAnimations();
        await DietState().toggleSpellCheck();
        await DietState.initialize();
        expect(DietState.dietCreationAnimations, true);
        expect(DietState.slowAnimations, true);
        expect(DietState.slowIngredientAnimations, false);
        expect(DietState.persistentIngredients, true);
        expect(DietState.spellCheck, false);
        await DietState().resetSettings();
        assertInitialDietState();
      });
      
      test('Testing DietState diet selection (getNumberSelected, updateNumberSelected)', () async {
        await initialize();

        expect(DietState().getNumberSelected(), 0);
        DietState().setIsChecked(0, true);
        expect(DietState().getNumberSelected(), 0);
        expect(DietState.getDietList()[0].isChecked, true);
        DietState().updateNumberSelected();
        expect(DietState().getNumberSelected(), 1);

        DietState().setIsChecked(3, true);
        expect(DietState().getNumberSelected(), 1);
        expect(DietState.getDietList()[3].isChecked, true);
        DietState().updateNumberSelected();
        expect(DietState().getNumberSelected(), 2);

        DietState().setIsChecked(0, false);
        expect(DietState().getNumberSelected(), 2);
        expect(DietState.getDietList()[0].isChecked, false);
        DietState().updateNumberSelected();
        expect(DietState().getNumberSelected(), 1);

        DietState().addDiet();
        DietState().updateNumberSelected();
        expect(DietState().getNumberSelected(), 1);


        // Checking preservation of diets checked after DietState().initialize and DietState().reset
        await DietState.initialize();
        expect(DietState.getDietList()[0].isChecked, false);
        expect(DietState().getNumberSelected(), 1);
        await DietState().reset();
        assertInitialDietState();
      });
    
      test('Testing DietState adding/removing single items from diet', skip: true, () async {
        // await initialize();

        // DietState().addDiet();
        // DietState().addDietItem(DietState.getDietList().length-1, true);
        // DietState().addDietItem(DietState.getDietList().length-1, false);
        // DietState().updateDietItem(DietState.getDietList().length-1, 0, 'a', true);
        // DietState().updateDietItem(DietState.getDietList().length-1, 0, 'b', false);
        
        // expect(DietState.getDietList()[DietState.getDietList().length-1].primaryItems,['a']);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].secondaryItems,['b']);

        // // Testing duplicate items
        // DietState().addDietItem(DietState.getDietList().length-1, true);
        // DietState().addDietItem(DietState.getDietList().length-1, false);

        // bool? temp;
        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'a', true);
        // expect(temp, true); 
        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'a', false);
        // expect(temp, true); 
        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'b', true);
        // expect(temp, false); 
        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'b', false);
        // expect(temp, false); 

        // expect(DietState.getDietList()[DietState.getDietList().length-1].primaryItems,['a','']);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].secondaryItems,['b','']);

        // // Testing case sensitivity
        // await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'aBcDe', true);
        // await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'fGhIj', false);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].primaryItems,['a','aBcDe']);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].secondaryItems,['b','fGhIj']);

        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'AbCde', true);
        // expect(temp, true); 
        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'AbCde', false);
        // expect(temp, true); 
        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'fgHIj', true);
        // expect(temp, false); 
        // temp = await DietState().updateDietItem(DietState.getDietList().length-1, 1, 'fgHIj', false);
        // expect(temp, false); 

        // // Testing removal
        // await DietState().removeDietItem(DietState.getDietList().length-1, 0, true);
        // await DietState().removeDietItem(DietState.getDietList().length-1, 0, false);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].primaryItems,['aBcDe']);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].secondaryItems,['fGhIj']);
        // await DietState().removeDietItem(DietState.getDietList().length-1, 0, true);
        // await DietState().removeDietItem(DietState.getDietList().length-1, 0, false);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].primaryItems,[]);
        // expect(DietState.getDietList()[DietState.getDietList().length-1].secondaryItems,[]);

        // // Testing 
        // await DietState().reset();
        // int counter = 0;
        // while(DietState.getDietList().length<DietState.maxDiets) {
        //   temp = await DietState().addDiet();
        //   await DietState().updateDietName(DietState.getDietList().length-1,counter.toString());
        //   expect(temp, null);
        //   counter++;
        // }
        // temp = await DietState().addDiet();
        // expect(temp, true);
        // await DietState().removeDiet(DietState.getDietList().length-1);
        // temp = await DietState().addDiet();
        // expect(temp, null);
        // temp = await DietState().addDiet();
        // expect(temp, false);
        // await DietState().updateDietName(DietState.getDietList().length-1, 'x');
        // temp = await DietState().addDiet();
        // expect(temp, true);
      });
    
      test('Testing DietState adding diet items in diet creation order', () async {
        await initialize();

        await DietState().addDiet();
        
        await addingOperation1();
        await addingOperation2();
        expect(DietState.getDietList().last.primaryItems.toSet(),{
          // From TestDiet1
          '1primarya',
          '1primaryb',
          '1primaryc',
          '1primaryd',
          // From TestDiet2
          '1secondarya',
          '2primarya',
          '2primaryb',
          '2primaryc',
          '2primaryd'
        });
        expect(DietState.getDietList().last.secondaryItems.toSet(),{
          // From TestDiet1
          '1secondaryb',
          '1secondaryc',
          '1secondaryd',
          // From TestDiet2
          '2secondarya',
          '2secondaryb',
          '2secondaryc',
          '2secondaryd'
        });
        
        await addingOperation3();

        expect(DietState.getDietList().last.primaryItems.toSet(),{
          // From TestDiet1
          '1primarya',
          '1primaryb',
          '1primaryc',
          '1primaryd',
          // From TestDiet2
          '1secondarya',
          '2primarya',
          '2primaryb',
          '2primaryc',
          '2primaryd',
          // From primary list
          '1secondaryb',
          '1secondaryc',
          '3primarya',
          '3primaryb'
        });
        expect(DietState.getDietList().last.secondaryItems.toSet(),{
          // From TestDiet1
          '1secondaryd',
          // From TestDiet2
          '2secondarya',
          '2secondaryb',
          '2secondaryc',
          '2secondaryd',
          // From secondary list
          '3secondarya',
        });
      
        await addingOperation4();

        assertDietsCorrectlyAdded();

        // Testing the above in different orders

        // Order 2
        await DietState().removeDiet(DietState.getDietList().length-1);  
        assertInitialDietState();
        await DietState().addDiet();
        
        await addingOperation2();
        await addingOperation1();
        await addingOperation4();
        await addingOperation3();

        assertDietsCorrectlyAdded();

        // Order 3
        await DietState().removeDiet(DietState.getDietList().length-1);  
        assertInitialDietState();
        await DietState().addDiet();

        await addingOperation3();
        await addingOperation2();
        await addingOperation1();
        await addingOperation4();

        assertDietsCorrectlyAdded();

        // Order 4
        await DietState().removeDiet(DietState.getDietList().length-1);  
        assertInitialDietState();
        await DietState().addDiet();

        await addingOperation4();
        await addingOperation1();
        await addingOperation2();
        await addingOperation3();

        // Order 5
        await DietState().removeDiet(DietState.getDietList().length-1);  
        assertInitialDietState();
        await DietState().addDiet();

        await addingOperation3();
        await addingOperation4();
        await addingOperation2();
        await addingOperation1();
        
        assertDietsCorrectlyAdded();

        // Order 6
        await DietState().removeDiet(DietState.getDietList().length-1);  
        assertInitialDietState();
        await DietState().addDiet();

        await addingOperation4();
        await addingOperation3();
        await addingOperation1();
        await addingOperation2();
        
        assertDietsCorrectlyAdded();


        await DietState().removeDiet(DietState.getDietList().length-1);  
        assertInitialDietState();
      });
    
      test('Testing diet name updating', () async {
        await initialize();

        bool? temp;
        await DietState().addDiet();
        temp = await DietState().updateDietName(DietState.getDietList().length-1, 'Name 1');

        expect(temp, null);

        await DietState().addDiet();
        temp = await DietState().updateDietName(DietState.getDietList().length-1, 'Name 2');

        expect(temp, null);
        expect(DietState.getDietList()[DietState.getDietList().length-2].name, 'Name 1');
        expect(DietState.getDietList()[DietState.getDietList().length-1].name, 'Name 2');


        temp = await DietState().updateDietName(DietState.getDietList().length-1, 'Name 2');

        expect(temp, null);
        expect(DietState.getDietList()[DietState.getDietList().length-2].name, 'Name 1');
        expect(DietState.getDietList()[DietState.getDietList().length-1].name, 'Name 2');

        temp = await DietState().updateDietName(DietState.getDietList().length-1, 'Name 1');

        expect(temp, true);
        expect(DietState.getDietList()[DietState.getDietList().length-2].name, 'Name 1');
        expect(DietState.getDietList()[DietState.getDietList().length-1].name, 'Name 2');

        temp = await DietState().updateDietName(DietState.getDietList().length-1, '');
        expect(temp, false);
        expect(DietState.getDietList()[DietState.getDietList().length-2].name, 'Name 1');
        expect(DietState.getDietList()[DietState.getDietList().length-1].name, 'Name 2');

        temp = await DietState().updateDietName(DietState.getDietList().length-1, 'Name 3');
        expect(temp, null);
        expect(DietState.getDietList()[DietState.getDietList().length-2].name, 'Name 1');
        expect(DietState.getDietList()[DietState.getDietList().length-1].name, 'Name 3');
      });
    });

    group('Test ingredient analysis', () {
      group('Testing trim function', () {
        test('Trim function simple tests', () {
          // Testing blank
          TrimReturn trimReturn = trim('');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);
          
          // Testing only beginning markers
          trimReturn = trim('ingredients:');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredients');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredlents:');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredlents');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ngredients:');

          expect(trimReturn.shortenedText, 'ngredients');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ngredients');

          expect(trimReturn.shortenedText, 'ngredients');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredient:');

          expect(trimReturn.shortenedText, 'ingredient');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredient');

          expect(trimReturn.shortenedText, 'ingredient');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);

          // Testing only end markers
          trimReturn = trim('contains');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, true);

          trimReturn = trim('caution');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, true);

          trimReturn = trim('.');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, true);

          trimReturn = trim('ontains');

          expect(trimReturn.shortenedText, 'ontains');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('contain');

          expect(trimReturn.shortenedText, 'contain');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);
        });

        test('Trim function complex tests', () {
          // Colon test
          TrimReturn trimReturn = trim('   i:ngr:ed  i:ents:   ');

          expect(trimReturn.shortenedText, 'ingred  ients');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, false);

          // Beginning Marker tests
          trimReturn = trim('ingredients:xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x x');

          expect(trimReturn.shortenedText, 'xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x x');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredients:    xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x x     ');

          expect(trimReturn.shortenedText, 'xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x x');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredient xxx, x,x ,x ,x x,x ,xxxingredientsxxxxxingredientsxxxx, xxxingredientxxxxxxxx,x, x,x,ingredientsx,x,,x ingredientx x     ');

          expect(trimReturn.shortenedText, 'xxxxxingredientsxxxx, xxxingredientxxxxxxxx,x, x,x,ingredientsx,x,,x ingredientx x');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          // Testing only end markers
          trimReturn = trim('xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x xcontains');

          expect(trimReturn.shortenedText, 'xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x x');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, true);

          trimReturn = trim('    xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x x     contains');

          expect(trimReturn.shortenedText, 'xxxxxxxxx, xxxxxxxxxxx,x, x,x,x,x,,x x x');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, true);

          trimReturn = trim('xx,contain x,x ,xcontains,x x,x ,xxxgreensxxxxxingdientsxxxx, xxxingrientcontains xxxxxxxx,x, x,xcontain,ingredx,x,,x ingreentx x  containsxxxcontain');

          expect(trimReturn.shortenedText, 'xx,contain x,x ,x');
          expect(trimReturn.trimBeginning, false);
          expect(trimReturn.trimEnd, true);

          // Testing both markers simulataneously
          trimReturn = trim('xingredientsx,x ,xcontans,x x,x ,xxxgreensxxxxxingredientsxxxx, xxxingrientcontains xxxxxxxx,x, x,xcontain,ingredx,x,,x ingreentx x  containsxxxcontain');

          expect(trimReturn.shortenedText, 'x,x ,xcontans,x x,x ,xxxgreensxxxxxingredientsxxxx, xxxingrient');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, true);

          trimReturn = trim('containsingredients');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, false);

          trimReturn = trim('ingredientscontains');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, true);

          trimReturn = trim('ingredientscontainsingredientscontainsingredients');

          expect(trimReturn.shortenedText, '');
          expect(trimReturn.trimBeginning, true);
          expect(trimReturn.trimEnd, true);
        });
      });

      test('Testing determineSeparationStyle function', () {
        // No parenthesis tests
        SeparationStyle separationStyle = determineSeparationStyle(',');
        expect(separationStyle, SeparationStyle.commaSeparated);

        separationStyle = determineSeparationStyle('x x x x x ,');
        expect(separationStyle, SeparationStyle.commaSeparated);

        separationStyle = determineSeparationStyle('x x x x x x ,');
        expect(separationStyle, SeparationStyle.indentationSeparated);

        // With parenthesis simple tests
        separationStyle = determineSeparationStyle('x x x x() x ,');
        expect(separationStyle, SeparationStyle.commaSeparated);

        separationStyle = determineSeparationStyle('x x x x(x) x ,');
        expect(separationStyle, SeparationStyle.commaSeparated);

        separationStyle = determineSeparationStyle('x x x(x x x x ) x(x x x x x x) x ,');
        expect(separationStyle, SeparationStyle.commaSeparated);

        separationStyle = determineSeparationStyle('x x x x()x x ,');
        expect(separationStyle, SeparationStyle.commaSeparated);

        separationStyle = determineSeparationStyle('x x x x (x) x x ,');
        expect(separationStyle, SeparationStyle.indentationSeparated);

        // Realistic tests

        separationStyle = determineSeparationStyle('x, x, x (x) x, x(x, x x, x), x x,');
        expect(separationStyle, SeparationStyle.commaSeparated);

        separationStyle = determineSeparationStyle('x   x    x    (x)   x   x (x    x x    x) x    x  ');
        expect(separationStyle, SeparationStyle.indentationSeparated);

        separationStyle = determineSeparationStyle('x   x    x    (x)   x   x (x, x x, x) x    x  ');
        expect(separationStyle, SeparationStyle.indentationSeparated);
      });

      test('Testing handleseparation function', () {
        const String shortenedText = 'a, (b, c) , d, e (ef, gh), f, g\n , \n h,() i, )j, \n, k, \n\n (l\nl2) \n m';

        SeparationStyle separationStyle = SeparationStyle.commaSeparated;
        List<String> result = handleSeparation(shortenedText, separationStyle);
        expect(result, ['a','','b','c','','d','e','ef','gh','','f','g','h','','','i','','j','','k','','l l2','m']);

        separationStyle = SeparationStyle.indentationSeparated;
        result = handleSeparation(shortenedText, separationStyle);
        expect(result, ['a','','b','c','','d','e','ef','gh','','f','g','','','h','','','i','','j','','','k','','','','l','l2','','m']);
      });
    
      group('Testing addLinesAndDetermineStatus function', () {
        test('basic tests, checking whether invalid ingredients are correctly recognized', () async {
          WidgetsFlutterBinding.ensureInitialized();
          SharedPreferences.setMockInitialValues({}); //todo: check this
          await DietState.initialize();
          DietState().setIsChecked(0, true); // Vegan diet is checked
          await DietState.loadDietData();
          
          final List<double> xInitialList = List.filled(15,0);
          final List<double> yInitialList = List.filled(15,0);
          final List<double> xFinalList = List.filled(15,0);
          final List<double> yFinalList = List.filled(15,0);

          final List<String> shortenedTextListFormat = [
            'a', 'b', 'c', 'd', 'e',
            'f', 'g', 'h', 'i', 'j',
            'k', 'l', 'm', 'n', 'o'
          ];
          final List<String> wordList = [
            'a', 'b', 'c', 'd', 'e',
            'f', 'g', 'h', 'i', 'j',
            'k', 'l', 'm', 'n', 'o'
          ];

          StatusLinesReturn functionReturn = addLinesAndDetermineStatus(shortenedTextListFormat, wordList, xInitialList, yInitialList, xFinalList, yFinalList);
          expect(functionReturn.status, Status.doesFit);

          wordList[1] = 'biotin';
          shortenedTextListFormat[1] = 'biotin'; 

          functionReturn = addLinesAndDetermineStatus(shortenedTextListFormat, wordList, xInitialList, yInitialList, xFinalList, yFinalList);
          expect(functionReturn.status, Status.possiblyFits);

          wordList[0] = 'beef';
          shortenedTextListFormat[0] = 'beef'; 

          functionReturn = addLinesAndDetermineStatus(shortenedTextListFormat, wordList, xInitialList, yInitialList, xFinalList, yFinalList);
          expect(functionReturn.status, Status.doesntFit);

          wordList[0] = 'organic minced beef';
          shortenedTextListFormat[0] = 'organic minced beef'; 

          functionReturn = addLinesAndDetermineStatus(shortenedTextListFormat, wordList, xInitialList, yInitialList, xFinalList, yFinalList);
          expect(functionReturn.status, Status.doesntFit);
        });

        test('complex tests', () async {
          WidgetsFlutterBinding.ensureInitialized();
          SharedPreferences.setMockInitialValues({}); //todo: check this
          await DietState.initialize();
          DietState().setIsChecked(0, true); // Vegan diet is checked
          await DietState.loadDietData();

          // testing extra characters inserted as well as ingredient being split across multiple
          List<String> shortenedTextListFormat = [
            ',a', 'b', 'organic minced beef', '(d', 'e',
            'f', ' :,  g, , ,   ,', ' h', 'i', 'j',
            'k', ',l,', ':m ,', 'grou:nd (biotin ,  lak:e', 'n ', 'o  '
          ];
          List<String> wordList = [
            'a', 'b,', 'organic', 'minced', 'beef', 'd', 'e)',
            'f', 'g', 'h:', 'i', ':j',
            ',,k', 'l', ':m', ' grou:nd  ', '(biotin , ', ' lak:e', 'n,  ,', ' o ,'
          ];

          List<double> xInitialList = List.filled(wordList.length,0);
          List<double> yInitialList = List.filled(wordList.length,0);
          List<double> xFinalList = List.filled(wordList.length,0);
          List<double> yFinalList = List.filled(wordList.length,0);

          StatusLinesReturn functionReturn = addLinesAndDetermineStatus(shortenedTextListFormat, wordList, xInitialList, yInitialList, xFinalList, yFinalList);
          expect(functionReturn.status, Status.doesntFit);
          expect(functionReturn.lines.length, wordList.length);
          expect(
            functionReturn.lines.asMap().entries.every((final entry) {
              final index = entry.key;
              final color = entry.value.color;
              if (index == 2 || index == 3 || index == 4) {
                return color == Colors.red;
              }
              if(index == 15 || index == 16 || index == 17) {
                return color == Colors.orange;
              }
              return color == Colors.green;
            }),
            isTrue,
          );


          shortenedTextListFormat = [
            ',a', ' ', 'fish ground lake', 'b', 'organic minced beef', '(d', 'e',
            'f', ' :,  g, , ,   ,' ,' ', ' h', 'i', 'j',
            'k', ',l,', ':m ,', 'grou:nd (biotin ,  lak:e', 'beef n ', 'o  '
          ];
          wordList = [
            'a', 'fish', 'ground', 'lake' , 'b,', 'organic', 'minced', 'beef', 'd', 'e)',
            'f', 'g', 'h:', 'i', ':j',
            ',,k', 'l', ':m', ' grou:nd  ', '(biotin , ', ' lak:e', 'beef n,  ,', ' o ,'
          ];

          xInitialList = List.filled(wordList.length,0);
          yInitialList = List.filled(wordList.length,0);
          xFinalList = List.filled(wordList.length,0);
          yFinalList = List.filled(wordList.length,0);

          functionReturn = addLinesAndDetermineStatus(shortenedTextListFormat, wordList, xInitialList, yInitialList, xFinalList, yFinalList);
          expect(functionReturn.status, Status.doesntFit);
          expect(functionReturn.lines.length, wordList.length);
          expect(
            functionReturn.lines.asMap().entries.every((final entry) {
              final index = entry.key;
              final color = entry.value.color;
              if (index == 1 || index == 2 || index == 3) {
                return color == Colors.red;
              }
              if(index == 5 || index == 6 || index == 7) {
                return color == Colors.red;
              }
              if(index == 18 || index == 19 || index == 20) {
                return color == Colors.orange;
              }
              return color == Colors.green;
            }),
            isTrue,
          );
        });
      });
    });
  
    // void main() {
    //   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    //     // Build our app and trigger a frame.

    //     // final List<CameraDescription> cameras = await availableCameras();
    //     // final CameraDescription firstCamera = cameras.first;
    //     // await DietState().initialize();
    //     // await dotenv.load();

    //     // await tester.pumpWidget(MyApp(camera: firstCamera));

    //     // // Verify that our counter starts at 0.
    //     // expect(find.text('0'), findsOneWidget);
    //     // expect(find.text('1'), findsNothing);

    //     // // Tap the '+' icon and trigger a frame.
    //     // await tester.tap(find.byIcon(Icons.add));
    //     // await tester.pump();

    //     // // Verify that our counter has incremented.
    //     // expect(find.text('0'), findsNothing);
    //     // expect(find.text('1'), findsOneWidget);
    //   });
    // }
  });
}
