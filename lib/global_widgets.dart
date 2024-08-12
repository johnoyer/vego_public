import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';

// globalDivider 

Widget globalDivider() {
  return const Divider(
    thickness: 2.0,
    height: 0,
    color: Colors.black
  );
}

// libraryCard

enum TextFeatures {
  large,
  normal,
  small,
}

const double interactableElevation = 7;
const double notInteractableElevation = 2;

Widget libraryCard(
  String? text, 
  final TextFeatures features, 
  {
    final Color? color, 
    final bool? alternate, 
    final IconData? icon,
    final Color? iconColor,
    final double? iconSize,
    final bool elevated = false
  }
) {
  if(text!=null) {
    text = (icon==null) ? text : ' $text';
  }
  final Color colorToUse = alternate != null ? Colors.black : Colors.white;
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
                // overflow: TextOverflow.ellipsis,
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


// globalTextField

Widget counter(
  final BuildContext context,
  {
    required final int currentLength,
    required final int? maxLength,
    required final bool isFocused,
  }
) {
  return Text(
    '$currentLength of $maxLength characters',
    semanticsLabel: 'character count',
  );
}

Widget globalTextField(
  final TextEditingController controller, 
  final ValueChanged<String> onChanged, 
  final int? maxLength, final int maxLines, 
  {final String? hintText, 
  final String? labelText,}
) {
  return PlatformWidget(
    ios: (final context) => StatefulBuilder(
      builder: (final context, final setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              placeholder: hintText,
              controller: controller,
              maxLines: maxLines,
              autocorrect: false, 
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(r'[\n\r]')
                ),
              ],
              //   labelText: labelText,
              onChanged: (final text) {
                onChanged(text);
                setState(() {}); // Trigger rebuild to update counter
              },
              maxLength: maxLength,
              style: kStyle4(Colors.black),
              cursorColor: Colors.black, // Keep the cursor visible
            ),
            Row(
              children: [
                const Spacer(),
                maxLength!= null ? Card(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  margin: EdgeInsets.zero,
                  child: Text(
                    '${controller.text.length}/$maxLength characters',
                    style: const TextStyle(fontSize: 10),
                    semanticsLabel: 'character count',
                  ),
                ) : Container(),
              ],
            ),
          ],
        );
      }
    ),
    android: (final context) => TextField(
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      buildCounter: maxLength!=null ? counter : null,
      controller: controller,
      maxLines: maxLines,
      autocorrect: false, 
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp(r'[\n\r]')
        ),
      ],
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
      ),
      onChanged: onChanged,
      maxLength: maxLength,
      style: kStyle4(Colors.black),
      cursorColor: Colors.black, // Keep the cursor visible
    ),
  );
}

// PlatformWidget

class PlatformWidget extends StatelessWidget {
  final WidgetBuilder ios;
  final WidgetBuilder android;

  const PlatformWidget({required this.ios, required this.android});

  @override
  Widget build(final BuildContext context) {
    return isAndroid() ? android(context) : ios(context);
  }
}

// informationButton

PlatformWidget informationButton(final BuildContext context, final String titleText, final infoText) {
  return PlatformWidget(
    ios: (final context) => CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (final BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(titleText),
              content: Text(infoText),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: questionMarkIconCard(),
    ),
    android: (final context) => InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (final BuildContext context) {
            return AlertDialog(
              title: Text(titleText),
              content: Text(infoText),
              actions: <Widget>[
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: questionMarkIconCard()
    ),
  );
}

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

// buildDietInfo (Used in ingredient recognition and in manual entry

Widget buildDietInfo(final BuildContext context) {
  return Consumer<DietState>(
    builder: (final context, final dietState, final child) {
      if (DietState().getStatus()==Status.none) {//status.none
        // Handle the case where status is none
        return Center(
          child: libraryCard('Enter an Ingredient to Get Started!', TextFeatures.large),
        );
      }

      Color color = Colors.black;
      IconData iconData = Icons.hourglass_empty;

      final List<String> dietNames = [];

      for (Diet diet in DietState.getDietList()) {
        if(diet.isChecked) {
          dietNames.add(diet.name);
        }
      }

      final int count = dietNames.length;
      // String dietText = 'These ingredients are ';
      String dietText = '';
      if(count<1) {
        print('error'); // TODO
      }

      if(DietState().getStatus()==Status.doesntFit) { // There are non conforming ingredients
        color = Colors.red;
        iconData = Icons.clear;
        dietText += 'Not ';
      } else if(DietState().getStatus()==Status.possiblyFits) { // Above is false, but there are possibly conforming ingredients
        color = Colors.orange;
        iconData = Icons.help;
        dietText += 'Possibly ';
      } else if(DietState().getStatus()==Status.doesFit) { // Both above are false: diet conforms
        color = Colors.green;
        iconData = Icons.check;
      }
      if(count==1) {
        dietText += dietNames[0];  
      } else if(count==2) {
        dietText += '${dietNames[0]} and ${dietNames[1]}';
      } else {
        String prefix = '';
        for (int i = 0; i < count - 1; i++) {
          prefix += '${dietNames[i]}, ';
        }
        prefix += 'and ${dietNames[count - 1]}';
        dietText += prefix;
      }

      const double iconSize = 80;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(iconSize/2),
            ),
            child: Center(
              child: Icon(
                iconData,
                size: iconSize*.9,
                color: Colors.white,
              ),
            ),
          ),
          libraryCard(
            dietText,
            TextFeatures.normal,
          )
        ],
      );
    }
  );
}