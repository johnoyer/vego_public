import 'package:flutter/material.dart';

// Widget globalDivider() {
//   return const Divider(
//     thickness: 2.0,
//     height: 0,
//     color: Colors.white
//   );
// }

Widget globalDivider() {
  return Container(
    decoration: BoxDecoration(
    boxShadow: [
        // BoxShadow(
        //   color: Colors.black.withOpacity(0.5), // Shadow color
        //   spreadRadius: 1,  // The spread of the shadow
        //   blurRadius: 2,   // The blur effect of the shadow
        //   // offset: Offset(5, 5), // Position of the shadow
        // ),
      ],
      border: Border.all(
        // color: Colors.black,
        // width: 1.5
      ),
      borderRadius: BorderRadius.circular(10.0), 
      // side: const BorderSide(color: Color.fromARGB(255, 4, 3, 49)),
      color: Colors.white,
    ),
    height: 4.0
  );
}