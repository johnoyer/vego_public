import 'package:flutter/material.dart';
import 'package:vego_flutter_project/global_widgets.dart';

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
    
    // path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => false;
}

Widget cameraIconCard() {
  return libraryCard(
    null,
    TextFeatures.large, // doesn't do anything in this case
    alternate: false,
    icon: Icons.camera_alt_sharp,
    iconSize: 50,
  );
}