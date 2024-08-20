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
    final bool elevated = false,
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
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.white.withOpacity(0.5),
        //     // spreadRadius: elevated ? 1 : 0,
        //     offset: Offset(elevated ? 2 : 0, elevated ? 2 : 0),
        //     blurRadius: 1,
        //   ),
        // ],
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
                    BoxShadow(
                      offset: const Offset(1, 1),
                      blurRadius: 1,
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
                  style: googleFonts(fontSize, color: colorToUse, shadow: true),
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

Widget questionMarkIconCard() {
  return libraryCard(
    null,
    TextFeatures.large,
    elevated: true,
    backGroundColor: ColorReturner().secondary,
    icon: Icons.question_mark,
    iconSize: 20,
  );
}