import 'package:flutter/material.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/diet_detail_page.dart';
import 'package:vego_flutter_project/diet_pages/diet_manager/helper_functions.dart';

class DietPage extends StatefulWidget {
  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  bool _editMode = false;
  bool _isInfoShown = false;

  void _switchMode() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              _isInfoShown ? Colors.black.withOpacity(0.5) : Colors.transparent, // Dark color with opacity
              BlendMode.darken,
            ),
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
                              final List<Widget>? icons = (DietState.getDietList()[index] is PresetDiet) ? // check whether the diet is preset
                                [(DietState.getDietList()[index] as PresetDiet).iconWidget] : 
                                ((DietState.getDietList()[index].isCustom()) &&
                                (DietState.getDietList()[index] as CustomDiet).dietFeatures != null &&
                                (DietState.getDietList()[index] as CustomDiet).dietFeatures!.isNotEmpty) ? // check whether the diet is custom and has a non empty dietFeatures list
                                (DietState.getDietList()[index] as CustomDiet)
                                  .dietFeatures!
                                  .map((final diet) => diet.iconWidget) // Convert each diet feature into its icon
                                  .toList() :
                                null;
                              return LabeledCheckbox(
                                isChecked: DietState.getDietList()[index].isChecked,
                                hidden: DietState.getDietList()[index].hidden,
                                label: (DietState.getDietList()[index].name=='')
                                  ? '[unnamed diet]' : DietState.getDietList()[index].name,
                                icons: icons,
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
                                  if(_isInfoShown) return; // do nothing if the page info is shown
                                  Navigator.push( 
                                    context,
                                    MaterialPageRoute(
                                      builder: (final context) =>
                                          DietDetailPage(dietIndex: index), // the diet will be from the mutable list in DietState
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
                globalDivider(),
                Padding(
                  // padding: const EdgeInsets.symmetric(vertical: 8.0), 
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 50 // to compensate for the width of the questionMarkIconCard
                      ),
                      const Spacer(),
                      LibraryButton( // Add new diet
                        onTap: () async => _isInfoShown ? null : await addNewDiet(context), // do nothing if the page info is shown
                        child: addNewDietCard()
                      ),
                      const Padding(padding: EdgeInsets.only(right: 5)),
                      LibraryButton( // Hide Diets
                        onTap: () => _isInfoShown ? null : _switchMode(), // do nothing if the page info is shown
                        child: HideDietsCard(editMode: _editMode),
                      ),
                      const Spacer(),
                      LibraryButton(
                        onTap: () {
                          _isInfoShown ? null : setState(() { // do nothing if the page info is shown
                            _isInfoShown = true;
                          });
                        },
                        child: questionMarkIconCard(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InfoSlider(
            isInfoShown: _isInfoShown,
            title: 'Diet Manager Info',
            info: info,
            onClose: () => setState(() {
              _isInfoShown = false;
            }),
          ),
        ],
      ),
    );
  }
}