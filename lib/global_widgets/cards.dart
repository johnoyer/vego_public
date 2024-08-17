import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/library/constants.dart';

enum TextFeatures {
  large,
  normal,
  small,
}

Widget libraryCard(
  String? text, 
  final TextFeatures features, 
  {
    final Color? color, 
    final bool? alternate, 
    final IconData? icon,
    final Color? iconColor,
    final double? iconSize,
    final bool elevated = false,
  }
) {
  if(text!=null) {
    text = (icon==null) ? text : ' $text';
  }
  final Color colorToUse = Colors.white;
  // final Color colorToUse = alternate != null ? Colors.black : Colors.white;
  return Card(
    color: color ??
      (
        alternate == null ?
        ColorReturner().primary :
        alternate ? ColorReturner().secondaryFixed :
        ColorReturner().primaryFixed
      ),
    shape: globalBorder,
    elevation: alternate==false||elevated ? interactableElevation : notInteractableElevation,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: iconSize!=null 
            ? iconSize==50
            ? const EdgeInsets.symmetric(horizontal: 35, vertical: 20) 
            : const EdgeInsets.all(15)
            : features == TextFeatures.normal || features == TextFeatures.small 
            ? const EdgeInsets.all(8.0) 
            : const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              (icon==null) ? Container()
              : Icon(
                icon,
                color: (iconColor!=null) ? iconColor : (alternate!=null) ? Colors.black : Colors.white,
                size: iconSize
              ),
              text != null ? Text(
                text, 
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: true,
                style: features == TextFeatures.normal
                    ? kStyle1(colorToUse)
                    : features == TextFeatures.small
                    ? kStyle2(colorToUse)
                    : kStyle3(colorToUse),
              ) : Container(),
            ],
          ),
        ),
      ],
    ),
  );
}

// Used for information buttons

Widget questionMarkIconCard() {
  return libraryCard(
    null,
    TextFeatures.large,
    elevated: true,
    color: ColorReturner().secondary,
    icon: Icons.question_mark,
    iconSize: 20,
  );
}