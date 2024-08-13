import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/global_widgets.dart';

Widget addNewDietCard() {
  return libraryCard(
    'Add New Diet',
    TextFeatures.normal,
    alternate: false,
    icon: Icons.add
  );
}

class HideDietsCard extends StatelessWidget {
  const HideDietsCard({
    super.key,
    required final bool editMode,
  }) : _editMode = editMode;

  final bool _editMode;

  @override
  Widget build(final BuildContext context) {
    return Card(
      shape: globalBorder,
      color: ColorReturner().primaryFixed,
      elevation: interactableElevation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 800),
              firstChild: const Icon(
                Icons.edit_off,
                color: Colors.black,
              ),
              secondChild: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
              crossFadeState: _editMode
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            Text(
              ' Hide Diets', 
              style: kStyle1(Colors.black)
            )
          ],
        ),
      ),
    );
  }
}

PlatformWidget mainPageInformationButton(final BuildContext context) {
  return informationButton(context,
    'Diet Manager Info',
    'Personal note TODO:  remove: prohibited dominates, then can be conforming dominates. if there is no allowed list, the ingredient passes. otherwise it fails iff it is not on the allowed list'
    'The diet manager allows you to select diets, add diets, edit and remove diets, and '
    'hide diets.'
    '\n\nTap on a diet to see information about it.'
    '\n\nTap the checkbox icon on the far right size of a diet to make that diet '
    '"checked". Foods that are allowed or prohibited by "checked" diets will be taken into '
    'account whenever ingredients are being evaluated in the app.'
    '\n\nTap the "add diet" button at the bottom of your screen to create a new diet.'
    '\n\nDiets that you create can be edited or permanently removed. To do either, tap '
    'on the diet and then tap the "Edit Diet" button.'
    '\n\nTo hide or unhide a diet from the list, tap the "Hide Diets" button. To hide/'
    'unhide a diet, tap on the "eye" icon for that diet. Note that "checked" diets may not '
    'be hidden.'
  );
}

Stack visibilityLocked() {
  return const Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Icon(
        Icons.visibility_outlined,
        color: Colors.grey,
        // size: 50,
      ),
      Positioned(
        bottom: 0,
        right: -3,
        child: Icon(
          Icons.lock,
          color: Colors.grey,
          size: 15,
        ),
      ),
    ],
  );
}

class VisibilityUnlocked extends StatelessWidget {
  const VisibilityUnlocked({
    super.key,
    required this.hidden,
  });

  final bool hidden;

  @override
  Widget build(final BuildContext context) {
    return AnimatedCrossFade(
      duration:
          const Duration(milliseconds: 500),
      firstChild: const Icon(
        Icons.visibility_outlined,
        color: Colors.green,
      ),
      secondChild: const Icon(
        Icons.visibility_off,
        color: Colors.red,
      ),
      crossFadeState: hidden
      ? CrossFadeState.showSecond
      : CrossFadeState.showFirst,
    );
  }
}

