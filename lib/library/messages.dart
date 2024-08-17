import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter/cupertino.dart';

// Dialogs 

// showErrorMessage (Used for multiple errors)
void showErrorMessage(final BuildContext context, final String text) {
  isAndroid() ? showDialog(
    context: context,
    builder: (final BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('Error')),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      );
    },
  ) : showCupertinoDialog(
    context: context,
    builder: (final BuildContext context) {
      return CupertinoAlertDialog(
        title: const Center(child: Text('Error')),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

// Used to show alerts

void showAlert(final BuildContext context, final int numSeconds, final String mainText, {final String? secondaryText}) {
  isAndroid() ? showDialog(
    context: context,
    builder: (final context) => AlertDialog(
      title: Text(mainText),
      content: secondaryText!=null ? Text(secondaryText) : null,
    )
  ) : showCupertinoDialog(
    context: context,
    builder: (final context) => CupertinoAlertDialog(
      title: Text(mainText),
      content: secondaryText!=null ? Text(secondaryText) : null,
    ),
  );
  // Automatically dismiss the AlertDialog after a few seconds
  Future.delayed(Duration(seconds: numSeconds), () {
    Navigator.of(context).pop();
  });
}