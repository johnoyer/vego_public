import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vego_flutter_project/library/barrel.dart';

Widget globalTextField(
  final TextEditingController controller, 
  final ValueChanged<String> onChanged, 
  final int? maxLength, final int maxLines, 
  {final String? hintText, 
  final String? labelText,}
) {
  return TextField(
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
      hintStyle: googleFonts(16),
      labelText: labelText,
      labelStyle: googleFonts(16),
    ),
    onChanged: onChanged,
    maxLength: maxLength,
    style: googleFonts(16),
    cursorColor: Colors.white, // Keep the cursor visible
  );
}

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
    style: googleFonts(13, color: Colors.white)
  );
}