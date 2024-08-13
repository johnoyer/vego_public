import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/global_widgets.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/diet_pages/new_diet_page/new_diet_page.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/diet_detail_page.dart';
import 'package:vego_flutter_project/diet_pages/diet_main_page/helper_functions.dart';

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
                isAndroid() ? InkWell( // Add new diet
                  onTap: () async => await addNewDiet(),
                  child: addNewDietCard()
                ) : CupertinoButton( // Add new diet
                  padding: EdgeInsets.zero,
                  onPressed: () async => await addNewDiet(),
                  child: addNewDietCard()
                ),
                isAndroid() ? InkWell( // Hide Diets
                  onTap: () {
                    _switchMode();
                  },
                  child: HideDietsCard(editMode: _editMode),
                ) : CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _switchMode();
                  },
                  child: HideDietsCard(editMode: _editMode),
                ),
                const Spacer(),
                mainPageInformationButton(context),
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

  Future<void> addNewDiet() async {
    final bool? tooManyDiets = await DietState().addDiet();
    if(tooManyDiets==null) {
      if(DietState.dietCreationAnimations) {
        if(!mounted) return;
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
      if(!mounted) return;
      showErrorMessage(context, 'There is already an unnamed diet, delete or name the unnamed diet before creating a new diet.');
    } else if(tooManyDiets) {
      if(!mounted) return;
      showErrorMessage(context, 'You have reached the limit of ${DietState.maxDiets} diets. Please delete a currently existing diet to create another one.');
    }
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