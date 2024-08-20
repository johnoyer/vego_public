import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_pages/new_diet_page/new_diet_page.dart';

Widget addNewDietCard(final double animationValue) {
  return libraryCard(
    'Add New Diet',
    TextFeatures.normal,
    alternate: false,
    animationValue: animationValue,
    icon: Icons.add
  );
}

class HideDietsCard extends StatelessWidget {
  const HideDietsCard({
    super.key,
    required final bool editMode,
    required final double animationValue,
  }) : _editMode = editMode, _animationValue = animationValue;

  final bool _editMode;
  final double _animationValue;

  @override
  Widget build(final BuildContext context) {
    final double offset = _animationValue != 1 ? 0 : 2;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: Offset(offset, offset),
            blurRadius: 1,
          ),
        ],
        border: Border.all(
          // color: Colors.black,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(10.0), 
        // side: const BorderSide(color: Color.fromARGB(255, 4, 3, 49)),
        color: ColorReturner().primaryFixed
      ),
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
              style: googleFonts(20, shadow: true, isPressed: _animationValue != 1)
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
    this.icons,
    required this.isChecked,
    required this.editMode,
    required this.hidden,
    required this.onChecked,
    required this.onHide,
    required this.onTap,
  });

  final String label;
  final List<Widget>? icons;
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
    : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: LibraryButton(
        onTap: onTap,
        childBuilder: (final double animationValue) {
        final double offset = animationValue != 1 ? 0 : 2;
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: Offset(offset, offset),
                  blurRadius: 1,
                ),
              ],
              border: Border.all(
                // color: Colors.black,
                width: 1.5
              ),
              borderRadius: BorderRadius.circular(10.0), 
              // side: const BorderSide(color: Color.fromARGB(255, 4, 3, 49)),
              color: ColorReturner().primary
            ),
            child: _row(animationValue),
          );
        }
      ),
    );
  }

  Widget _row (final double animationValue) {
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
                  if (icons != null) ...icons!.map((final widget) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          globalShadow(animationValue!=1, color: Colors.black)
                        ],
                        shape: BoxShape.circle
                      ),
                      child: widget
                    ),
                  )),
                  Text(
                    label, 
                    style: googleFonts(20, shadow: true, isPressed: animationValue != 1),
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
                childBuilder: (final double animationValue) {
                  return isChecked 
                  ? visibilityLocked()
                  : VisibilityUnlocked(hidden: hidden);
                }
              ) : LibraryButton(
                onTap: onHide,
                childBuilder: (final double animationValue) {
                  return isChecked 
                  ? visibilityLocked()
                  : VisibilityUnlocked(hidden: hidden);
                }
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