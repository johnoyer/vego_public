import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/button.dart';

Widget libraryNavigationBar(final VoidCallback onExit, final text) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: ColorReturner().primary,
      border: const Border(
        bottom: BorderSide(
          // color: Colors.black, // Border color
          width: 2.0, // Border width
        ),
      )
    ),
    child: Row(
      children: [
        SizedBox(
          width: 50,
          child: LibraryButton(
            onTap: onExit,
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        Card( // Provides text
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            )
          ),
        ),
        const Spacer(),
        const SizedBox(width: 50)
      ],
    ),
  );
}