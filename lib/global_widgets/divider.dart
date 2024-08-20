import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';

// Widget globalDivider() {
//   return const Divider(
//     thickness: 2.0,
//     height: 0,
//     color: Colors.white
//   );
// }

Widget globalDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          globalShadow(color: Colors.black.withOpacity(0.5))
        ],
        border: Border.all(
          // color: Colors.black,
          // width: 1.5
        ),
        borderRadius: BorderRadius.circular(1.5), 
        // side: const BorderSide(color: Color.fromARGB(255, 4, 3, 49)),
        color: Colors.white,
      ),
      height: 3
    ),
  );
}