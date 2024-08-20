import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_pages/diet_edit_page/diet_edit_page.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';


Widget itemsDisplayWidget(final List<String> inputList) {
  return Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Text(
            capitalizeFirstLetterOfEveryWord(inputList).join(', '), 
            style: googleFonts(17, color: Colors.black)
          )
        ),
      ),
    ),
  );
}

Widget editDietButton (final BuildContext context, final int dietIndex, final bool isInfoShown) {
  return LibraryButton(
    onTap: () {
      if(isInfoShown) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (final context) => DietEditPage(dietIndex: dietIndex),
        ),
      );
    },
    childBuilder: (final double animationValue) {
      return editDietCard(animationValue);
    }
  );
}

Widget editDietCard(final double animationValue) {
  return libraryCard(
    'Edit Diet',
    TextFeatures.normal,
    icon: Icons.edit,
    alternate: false,
    animationValue: animationValue
  );
}

Widget dietInfoWidget(final Diet diet) { // also used for new diet page
  return Card(
    color: ColorReturner().secondaryFixed,
    shape: globalBorder,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          libraryCard(
            'Diet Info:', 
            TextFeatures.normal, 
            icon: Icons.question_mark,
            alternate: false,
          ),
          Expanded(
            child: Text(
              (diet.dietInfo == '') ? 
              '[no diet info provided]' : diet.dietInfo,
            ),
          ),
        ],
      ),
    ),
  );
}