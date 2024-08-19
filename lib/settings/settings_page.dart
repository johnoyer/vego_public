import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/settings/helper_functions.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isInfoShown = false;

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Settings',
                    style: googleFonts(30, shadow: true)
                  )
                ),
                globalDivider(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SettingsRow(
                        isInfoShown: _isInfoShown,
                        switchValue: DietState.dietCreationAnimations,
                        toggleFunction: DietState().toggleDietCreationAnimations,
                        text: 'Enable new diet animations: '
                      ),
                      globalDivider(),
                      SettingsRow(
                        isInfoShown: _isInfoShown,
                        switchValue: DietState.slowAnimations,
                        toggleFunction: DietState().toggleSlowAnimations,
                        text: 'Enable slow diet animations: '
                      ),
                      globalDivider(),
                      SettingsRow(
                        isInfoShown: _isInfoShown,
                        switchValue: DietState.slowIngredientAnimations,
                        toggleFunction: DietState().toggleSlowIngredientAnimations,
                        text: 'Enable slow animations in ingredient recognition: ',
                      ),
                      globalDivider(),
                      SettingsRow(
                        isInfoShown: _isInfoShown,
                        switchValue: DietState.persistentIngredients,
                        toggleFunction: DietState().togglePersistentIngredients,
                        text: 'Enable ingredient persistence: '
                      ),
                      globalDivider(),
                      SettingsRow(
                        isInfoShown: _isInfoShown,
                        switchValue: DietState.spellCheck,
                        toggleFunction: DietState().toggleSpellCheck,
                        text: 'Enable spell checking during ingredient recognition: '
                      ),
                      globalDivider(),
                      // const Spacer(),
                      LibraryButton(
                        onTap: () {
                          _isInfoShown ? null : showCupertinoDialog( // do nothing if the info page is shown
                            context: context,
                            builder: (final BuildContext context) {
                              return const DeletionWidget(
                                titleText: 'Delete Custom Diets', 
                                noticeText: 'Are you sure you want to permanently delete all custom diets and reset diet data? Note that this action cannot be undone.'
                              );
                            },
                          );
                        },
                        child: libraryCard(
                          'Delete custom diets and restore default app state',
                          TextFeatures.small,
                          icon: Icons.delete,
                          alternate: false,
                        )
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 60),
                          const Spacer(),
                          LibraryButton(
                            onTap: () {
                              _isInfoShown ? null : showCupertinoDialog( // do nothing if the info page is shown
                                context: context,
                                builder: (final BuildContext context) {
                                  return const DeletionWidget(
                                    titleText: 'Reset Settings', 
                                    noticeText: 'Are you sure you want to reset settings?'
                                  );
                                },
                              );
                            },
                            child: libraryCard(
                              'Restore Settings to defaults',
                              TextFeatures.small,
                              icon: Icons.refresh,
                              alternate: false,
                            )
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
                      const Spacer(),
                    ],
                  ),
                ),],
            ),
          ),
          InfoSlider(
            isInfoShown: _isInfoShown,
            title: 'Settings Info',
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