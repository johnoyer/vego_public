import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';

const String info = 'Note: all options are recommended to be turned on';

const double selectorWidth = 450;

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