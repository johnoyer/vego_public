import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';

enum TextFeatures {
  large,
  normal,
  smallnormal,
  small,
}

Widget libraryCard(
  String? text, 
  final TextFeatures features, 
  {
    final Color? backGroundColor, 
    final bool? alternate, 
    final IconData? icon,
    final Color? iconColor,
    final double? iconSize,
    // final bool elevated = false,
    final Widget? fancyIcon,
    final double? animationValue
  }
) {
  if(text!=null) {
    text = (icon==null&&fancyIcon==null) ? text : ' $text';
  }
  // final Color colorToUse = Colors.white;
  final Color colorToUse = (alternate != null && alternate) ? Colors.black : Colors.white;
  final double fontSize = features == TextFeatures.normal
      ? 20
      : features == TextFeatures.small
      ? 15
      : features == TextFeatures.smallnormal
      ? 17
      : 30;
  final bool isPressed = (animationValue!=null && animationValue!=1);
  final bool globalShadowIsPressed = isPressed || animationValue==null; // use animation value to determine elevation
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          globalShadow(globalShadowIsPressed)
          // spreadRadius: elevated ? 1 : 0,
        ],
        border: Border.all(
          // color: Colors.black,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(10.0), 
        // side: const BorderSide(color: Color.fromARGB(255, 4, 3, 49)),
        color: backGroundColor ??
          (
            alternate == null ?
            ColorReturner().primary :
            alternate ? ColorReturner().secondaryFixed :
            ColorReturner().primaryFixed
          ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: iconSize!=null 
              ? iconSize==50
              ? const EdgeInsets.symmetric(horizontal: 35, vertical: 20) 
              : const EdgeInsets.all(15)
              : features == TextFeatures.normal || features == TextFeatures.small || features == TextFeatures.smallnormal
              ? const EdgeInsets.all(8.0) 
              : const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                (icon==null) ? Container()
                : Icon(
                  icon,
                  color: iconColor ?? colorToUse,
                  size: iconSize,
                  shadows: [
                    globalShadow( // hide the shadow if isPressed is true
                      isPressed,
                      offset: 1,
                      blurRadius: 1, // TODO: check
                      color: (colorToUse == Colors.white ? 
                          Colors.black : Colors.white),
                    ),
                  ]
                ),
                (fancyIcon==null) ? Container()
                : fancyIcon,
                text != null ? Text(
                  text, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  softWrap: true,
                  style: googleFonts(fontSize, color: colorToUse, shadow: true, isPressed: (animationValue ?? 1) != 1), // isPressed is false if animationValue isn't provided
                ) : Container(),
              ],
            ),
          ),
        ],
        ),
    ),
  );
}

// Used for information buttons

Widget questionMarkIconCard(final double animationValue) {
  return libraryCard(
    null,
    TextFeatures.large,
    animationValue: animationValue,
    backGroundColor: ColorReturner().secondary,
    icon: Icons.question_mark,
    iconSize: 20,
  );
}

