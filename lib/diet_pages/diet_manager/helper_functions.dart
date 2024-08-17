import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_pages/new_diet_page/new_diet_page.dart';

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
              style: kStyle1(Colors.white)
            )
          ],
        ),
      ),
    );
  }
}

const String info = 'Personal note TODO:  remove: prohibited dominates, then can be conforming '
  'dominates. if there is no allowed list, the ingredient passes. otherwise it fails iff it is not on the allowed list'
  ' - The diet manager allows you to select diets, add diets, edit and remove diets, and '
  'hide diets.'
  '\n\n - Tap on a diet to see information about it.'
  '\n\n - Tap the checkbox icon on the far right size of a diet to make that diet '
  '"checked". Foods that are allowed or prohibited by "checked" diets will be taken into '
  'account whenever ingredients are being evaluated in the app.'
  '\n\n - Tap the "add diet" button at the bottom of your screen to create a new diet.'
  '\n\n - Diets that you create can be edited or permanently removed. To do either, tap '
  'on the diet and then tap the "Edit Diet" button.'
  '\n\n - To hide or unhide a diet from the list, tap the "Hide Diets" button. To hide/'
  'unhide a diet, tap on the "eye" icon for that diet. Note that "checked" diets may not '
  'be hidden.';

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

Future<void> addNewDiet(final BuildContext context) async {
  final bool? tooManyDiets = await DietState().addDiet();
  if(tooManyDiets==null) {
    if(DietState.dietCreationAnimations) {
      if(!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (final context) => NewDietPage(
            index: DietState.getDietList().length - 1,
          ),
        ),
      );
    }
  } else if (!tooManyDiets) {
    if(!context.mounted) return;
    showErrorMessage(context, 'There is already an unnamed diet, delete or name the unnamed diet before creating a new diet.');
  } else if(tooManyDiets) {
    if(!context.mounted) return;
    showErrorMessage(context, 'You have reached the limit of ${DietState.maxDiets} diets. Please delete a currently existing diet to create another one.');
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    this.icon,
    required this.isChecked,
    required this.editMode,
    required this.hidden,
    required this.onChecked,
    required this.onHide,
    required this.onTap,
  });

  final String label;
  final Widget? icon;
  final bool isChecked;
  final bool editMode;
  final bool hidden;
  final VoidCallback onHide;
  final ValueChanged<bool?> onChecked;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return hidden && !editMode
    ? Container()
    : LibraryButton(
      onTap: onTap,
      child: Card(
        shape: globalBorder,
        color: ColorReturner().primary,
        elevation: 2,
        child: _row(),
      ),
    );
  }

  Widget _row () {
    return Row(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 30,
            width: 30,
          )
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon == null ? Container() : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: dietIconWrapper(icon!),
                  ),
                  Text(
                    label, 
                    style: kStyle1(Colors.white)
                  ),
                ],
              )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 30,
            width: 30,
            child: Center(
              child: editMode ? 
              isAndroid() ? LibraryButton(
                onTap: onHide,
                child: isChecked 
                ? visibilityLocked()
                : VisibilityUnlocked(hidden: hidden),
              ) : LibraryButton(
                onTap: onHide,
                child: isChecked 
                ? visibilityLocked()
                : VisibilityUnlocked(hidden: hidden),
              ) : PlatformWidget(
                ios: (final context) => CupertinoCheckbox(
                  value: isChecked,
                  onChanged: (final bool? newValue) {
                    onChecked(newValue!);
                  },
                  activeColor: const Color.fromARGB(255, 161, 151, 177),
                  checkColor: Colors.white,
                  focusColor: Colors.blue,
                ),
                android: (final context) => Checkbox(
                  value: isChecked,
                  onChanged: (final bool? newValue) {
                    onChecked(newValue!);
                  },
                  activeColor: const Color.fromARGB(255, 161, 151, 177),
                  checkColor: Colors.white,
                  focusColor: Colors.blue,
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}