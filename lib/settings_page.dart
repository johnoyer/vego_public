import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/global_widgets.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(final BuildContext context) {
    return SafeArea(
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
            child: SizedBox(
              width: 475,
              child: PlatformWidget(
                ios: (final context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    libraryCard(
                      'Note: all options are recommended to be turned on',
                      TextFeatures.small,
                      alternate: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable new diet animations: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: DietState.dietCreationAnimations,
                          onChanged: (final newValue) {
                            DietState().toggleDietCreationAnimations();
                          },
                          activeColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable slow diet animations: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: DietState.slowAnimations,
                          onChanged: (final newValue) {
                            DietState().toggleSlowAnimations();
                          },
                          activeColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable slow animations in ingredient recognition: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: DietState.slowIngredientAnimations,
                          onChanged: (final newValue) {
                            DietState().toggleSlowIngredientAnimations();
                          },
                          activeColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable ingredient persistence: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: DietState.persistentIngredients,
                          onChanged: (final newValue) {
                            DietState().togglePersistentIngredients();
                          },
                          activeColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable spell checking during ingredient recognition: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: DietState.spellCheck,
                          onChanged: (final newValue) {
                            DietState().toggleSpellCheck();
                          },
                          activeColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showCupertinoDialog(
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showCupertinoDialog(
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
                  ],
                ),
              android: (final context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    libraryCard(
                      'Note: all options are recommended to be turned on',
                      TextFeatures.normal,
                      alternate: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable new diet animations: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: DietState.dietCreationAnimations,
                          onChanged: (final newValue) {
                            DietState().toggleDietCreationAnimations();
                          },
                          activeTrackColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable slow diet animations: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: DietState.slowAnimations,
                          onChanged: (final newValue) {
                            DietState().toggleSlowAnimations();
                          },
                          activeTrackColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable slow animations in ingredient recognition: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: DietState.slowIngredientAnimations,
                          onChanged: (final newValue) {
                            DietState().toggleSlowIngredientAnimations();
                          },
                          activeTrackColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable ingredient persistence: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: DietState.persistentIngredients,
                          onChanged: (final newValue) {
                            DietState().togglePersistentIngredients();
                          },
                          activeTrackColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enable spell checking during ingredient recognition: ',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: DietState.spellCheck,
                          onChanged: (final newValue) {
                            DietState().toggleSpellCheck();
                          },
                          activeTrackColor: ColorReturner().primary,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
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
                    InkWell(
                      onTap: () {
                        showDialog(
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeletionWidget extends StatelessWidget {
  const DeletionWidget({
    super.key,
    required this.titleText,
    required this.noticeText,
  });

  final String titleText;
  final String noticeText;

  @override
  Widget build(final BuildContext context) {
    return PlatformWidget(
      ios: (final context) => CupertinoAlertDialog (
        title: Text(titleText),
        content: Text(noticeText),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () {
              // Reset diets
              DietState().reset();
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
      android: (final context) => AlertDialog(
        title: Text(titleText),
        content: Text(noticeText),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              // Reset diets
              DietState().reset();
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
  }
}