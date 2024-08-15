import 'dart:math';
import 'package:flutter/material.dart';

// Used for animating the lines underlining text

class LinePainter extends CustomPainter {
  final List<LineData> lines;
  final double originalHeight;
  final double newHeight;
  final double originalWidth;
  final double newWidth;
  final AnimationController controller;

  LinePainter({
    required this.lines, 
    required this.originalHeight, 
    required this.newHeight, 
    required this.originalWidth, 
    required this.newWidth, 
    required this.controller
  }) : super(repaint: controller);

  @override
  void paint(final Canvas canvas, final Size size) {
    for (int i=0; i<lines.length; i++) {
      final line = lines[i];

      final paint = Paint()
        ..color = line.color
        ..strokeWidth = 2.0 //TODO: may adjust
        ..strokeCap = StrokeCap.round;
      
      final int numberOfLines = lines.length;
      final int numberSimultaneousAnimations = sqrt(numberOfLines).toInt(); // Can change
      // 1 == unitsPerAnimation + unitsPerAnimation/numberSimultaneousAnimations*(numberofLines-1)
      final double unitsPerAnimation = 1/(1+(numberOfLines.toDouble()-1)/numberSimultaneousAnimations.toDouble());
      final double startPoint = i*unitsPerAnimation/numberSimultaneousAnimations.toDouble();
      final double endPoint = startPoint+unitsPerAnimation;
      final double progress = controller.value > startPoint ? 
                              controller.value < endPoint ? 
                              (controller.value-startPoint)/(unitsPerAnimation) : 1 : 0;

      final double newStartDx = line.start.dx * newWidth/originalWidth;
      final double newStartDy = line.start.dy * newHeight/originalHeight;
      final double newEndDx = newStartDx + (line.end.dx-line.start.dx) * newWidth/originalWidth * progress;
      final double newEndDy = newStartDy + (line.end.dy-line.start.dy) * newWidth/originalWidth * progress;

      progress != 0 ? canvas.drawLine(Offset(newStartDx, newStartDy), Offset(newEndDx, newEndDy), paint) : null; // Only paint if 'progress' has begun to change
    }
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) {
    return false; // never repaint (no need to)
  }
}

class LineData {
  final Offset start;
  final Offset end;
  final Color color;

  LineData(this.start, this.end, this.color);
}
