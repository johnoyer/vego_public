import 'package:flutter/material.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';

// Used to create the overlay for the CameraPreview

enum Position {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight
}

Widget cornerIndicator(final Position position) {
  const double edgeDistance = 50;
  return Positioned(
    top: position==Position.topLeft||position==Position.topRight ? edgeDistance : null,
    bottom: position==Position.bottomLeft||position==Position.bottomRight ? edgeDistance : null,
    left: position==Position.topLeft||position==Position.bottomLeft ? edgeDistance : null,
    right: position==Position.topRight||position==Position.bottomRight ? edgeDistance : null,
    child: CustomPaint(
      painter: LShapePainter(position: position)
    )
  );
}

class LShapePainter extends CustomPainter {
  final Position position;

  LShapePainter({required this.position});

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeJoin = StrokeJoin.round;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5) // Shadow color with opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0); // Apply blur to create shadow effect

    const double offset = 20.0;
    // final double length = size.width - offset;

    final Path path = Path();

    if (position==Position.topLeft||position==Position.bottomLeft) {
      path.moveTo(offset, 0);
    } else {// bottomRight or topRight
      path.moveTo(-offset, 0);
    }
    path.lineTo(0, 0); 
    if (position==Position.topLeft||position==Position.topRight) {
      path.lineTo(0, offset);
    } else {// bottomLeft or bottomRight
      path.lineTo(0, -offset);
    }

    // Draw shadow path
    final Path shadowPath = Path();

    const double shadowOffset = 2;

    if (position==Position.topLeft||position==Position.bottomLeft) {
      shadowPath.moveTo(offset-shadowOffset, 0+shadowOffset);
    } else {// bottomRight or topRight
      shadowPath.moveTo(-offset-shadowOffset, 0+shadowOffset);
    }
    shadowPath.lineTo(0-shadowOffset, 0+shadowOffset); 
    if (position==Position.topLeft||position==Position.topRight) {
      shadowPath.lineTo(0-shadowOffset, offset+shadowOffset);
    } else {// bottomLeft or bottomRight
      shadowPath.lineTo(0-shadowOffset, -offset+shadowOffset);
    }

    canvas.drawPath(shadowPath, shadowPaint); // Draw shadow first
    canvas.drawPath(path, paint); // Draw the main path
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => false;
}

Widget cameraIconCard(final double animationValue) {
  return libraryCard(
    null,
    TextFeatures.large, // doesn't do anything in this case
    animationValue: animationValue,
    alternate: false,
    icon: Icons.camera_alt_sharp,
    iconSize: 50,
  );
}