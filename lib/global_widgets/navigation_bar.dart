import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/button.dart';

Widget libraryNavigationBar(final VoidCallback onExit, final text, final VoidCallback? onQuestion, final Widget? fancyIcon) {
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
        fancyIcon ?? Container(),
        fancyIcon !=null ? const Padding(padding: EdgeInsets.only(right: 4.0)) : Container(), // add padding if there is an icon
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
        SizedBox(
          width: 50,
          child: onQuestion != null ? 
          LibraryButton(
            onTap: onQuestion,
            child: const Icon(
              Icons.question_mark,
              size: 30,
              color: Colors.white,
            ),
          ) : 
          Container(),
        )
      ],
    ),
  );
}