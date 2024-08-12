import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/global_widgets.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/diet_pages/new_diet_page/new_diet_page.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/diet_detail_page.dart';

class DietPage extends StatefulWidget {
  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  bool _editMode = false;

  void _switchMode() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<DietState>(builder: (final context, final dietState, final child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: DietState.getDietList().length,
                      itemBuilder: (final context, final index) {
                        return LabeledCheckbox(
                          isChecked: DietState.getDietList()[index].isChecked,
                          hidden: DietState.getDietList()[index].hidden,
                          label: (DietState.getDietList()[index].name=='')
                            ? '[unnamed diet]' : DietState.getDietList()[index].name,
                          onChecked: (final bool? newValue) {
                            if (newValue!) {
                              DietState().toggleIsChecked(index);
                              DietState().updateNumberSelected();
                            } else if (!newValue && DietState().getNumberSelected() > 1) {
                              DietState().toggleIsChecked(index);
                              DietState().updateNumberSelected();
                            } else {
                              showErrorMessage(context, 'Please select at least one diet.');
                            }
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (final context) =>
                                    DietDetailPage(dietIndex: index),
                              ),
                            );
                          },
                          onHide: () {
                            if(DietState.getDietList()[index].isChecked) {
                              showErrorMessage(context,'Selected diets cannot be hidden. Unselect the diet to hide it.');
                            } else {
                              DietState().toggleHidden(index);
                            }
                          },
                          editMode: _editMode,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(3),
          ),
          globalDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 70,
                ),
                const Spacer(),
                InkWell( // Add new diet
                  onTap: () async {
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
                  },
                  child: libraryCard(
                    'Add New Diet',
                    TextFeatures.normal,
                    alternate: false,
                    icon: Icons.add
                  )
                ),
                InkWell( // Hide Diets
                  onTap: () {
                    _switchMode();
                  },
                  child: Card(
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
                  ),
                ),
                const Spacer(),
                informationButton(context,
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
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.onChecked,
    required this.isChecked,
    required this.onTap,
    required this.editMode,
    required this.hidden,
    required this.onHide,
  });

  final String label;
  final bool isChecked;
  final ValueChanged<bool?> onChecked;
  final VoidCallback onHide;
  final VoidCallback onTap;
  final bool editMode;
  final bool hidden;

  @override
  Widget build(final BuildContext context) {
    return hidden && !editMode
    ? Container()
    : Card(
      shape: globalBorder,
      color: ColorReturner().primary,
      elevation: 2,
      child: isAndroid() ? InkWell(
        focusColor: Colors.black,
        onTap: () => onTap(),
        child: _row()
      ) : CupertinoButton(
        onPressed: () => onTap(),
        padding: EdgeInsets.zero,
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
            child: Center(child: Text(label, style: kStyle1(Colors.white))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 30,
            width: 30,
            child: Center(
              child: editMode ? InkWell(
                onTap: onHide,
                child: isChecked 
                ? const Stack(
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
                )
                : AnimatedCrossFade(
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
                ),
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
