import 'package:flutter/material.dart';

// Used to enclose diet icons

Widget dietIconWrapper(final Widget child, final bool diagonal) {
  return Container(
    width: 30.0,
    height: 30.0,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle, // Make the container circular
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: Align(
            child: child
          )
        ),
        // Diagonal line
        diagonal ? Positioned.fill(
          child: CustomPaint(
            painter: DiagonalLinePainter(),
          ),
        ) : Container(),
      ],
    ),
  );
}

class DiagonalLinePainter extends CustomPainter {

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    // Draw a line from top left to bottom right
    canvas.drawLine(
      // Offset((1-sqrt(.5))/2*size.width, (1-sqrt(.5))/2*size.height),
      // Offset((1+sqrt(.5))/2*size.width, (1+sqrt(.5))/2*size.height),
      Offset((1-2/3)/2*size.width, (1-1/2)/2*size.height),
      Offset((1+2/3)/2*size.width, (1+1/2)/2*size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) {
    return false;
  }
}
