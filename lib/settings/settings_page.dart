import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/global_widgets.dart';
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
                  child: libraryCard(
                    'Settings',
                    TextFeatures.large,
                  ),
                ),
                globalDivider(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: selectorWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            libraryCard(
                              'Enable new diet animations: ',
                              TextFeatures.small,
                              alternate: true,
                            ),
                            const Spacer(),
                            isAndroid() ? Switch(
                              value: DietState.dietCreationAnimations,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleDietCreationAnimations(); // do nothing if the info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ) : CupertinoSwitch(
                              value: DietState.dietCreationAnimations,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleDietCreationAnimations(); // do nothing if the info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: selectorWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            libraryCard(
                              'Enable slow diet animations: ',
                              TextFeatures.small,
                              alternate: true
                            ),
                            const Spacer(),
                            isAndroid() ? Switch(
                              value: DietState.slowAnimations,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleSlowAnimations(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ) : CupertinoSwitch(
                              value: DietState.slowAnimations,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleSlowAnimations(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: selectorWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            libraryCard(
                              'Enable slow animations in ingredient recognition: ',
                              TextFeatures.small,
                              alternate: true,
                            ),
                            const Spacer(),
                            isAndroid() ? Switch(
                              value: DietState.slowIngredientAnimations,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleSlowIngredientAnimations(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ) : CupertinoSwitch(
                              value: DietState.slowIngredientAnimations,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleSlowIngredientAnimations(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: selectorWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            libraryCard(
                              'Enable ingredient persistence: ',
                              TextFeatures.small,
                              alternate: true
                            ),
                            const Spacer(),
                            isAndroid() ? Switch(
                              value: DietState.persistentIngredients,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().togglePersistentIngredients(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ) : CupertinoSwitch(
                              value: DietState.persistentIngredients,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().togglePersistentIngredients(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: selectorWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            libraryCard(
                              'Enable spell checking during ingredient recognition: ',
                              TextFeatures.small,
                              alternate: true
                            ),
                            const Spacer(),
                            isAndroid() ? Switch(
                              value: DietState.spellCheck,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleSpellCheck(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ) : CupertinoSwitch(
                              value: DietState.spellCheck,
                              onChanged: (final newValue) {
                                _isInfoShown ? null : DietState().toggleSpellCheck(); // do nothing if info page is shown
                              },
                              activeColor: ColorReturner().primary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      isAndroid() ? InkWell(
                        onTap: () {
                          _isInfoShown ? null : showDialog( // do nothing if the info page is shown
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
                      ) : CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
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
                          const SizedBox(width: 100),
                          const Spacer(),
                          isAndroid() ? InkWell(
                            onTap: () {
                              _isInfoShown ? null : showDialog( // do nothing if the info page is shown
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
                          ) : CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
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
                          SizedBox(
                            width: 100,
                            child: isAndroid() ? InkWell(
                              onTap: () {
                                _isInfoShown ? null : setState(() { // do nothing if the page info is shown
                                  _isInfoShown = true;
                                }); 
                              },
                              child: questionMarkIconCard(),
                            ) : CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _isInfoShown ? null : setState(() { // do nothing if the page info is shown
                                  _isInfoShown = true;
                                }); 
                              },
                              child: questionMarkIconCard(),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
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