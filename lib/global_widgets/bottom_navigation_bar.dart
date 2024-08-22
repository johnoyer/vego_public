import 'package:vego_flutter_project/library/barrel.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {

  const CustomBottomNavigationBar();

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

const int numItems = 5;

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final Color selectedItemColor =  const Color.fromARGB(255, 70, 20, 16);

  int _previouslySelectedIndex = 0;
  int _selectedIndex = 0;
  static const double containerHeight = 60;

  @override
  Widget build(final BuildContext context) {
    final double availableWidth = MediaQuery.of(context).size.width;
    return Container(
      height: containerHeight,
      color: ColorReturner().bottombarColor,
      child: Stack(
        children: [
          AnimatedPositioned( // blue section of the bottom bar
            top: 2, // need to push it a bit down so that the path has enough room
            curve: Curves.easeInOutQuad,
            left: (availableWidth/(numItems+1))/(numItems+1) + availableWidth/(numItems+1)*(numItems+2)/(numItems+1)*_selectedIndex - availableWidth,
            duration: Duration(milliseconds: ((_previouslySelectedIndex-_selectedIndex).abs()+2)*150),
            child: ClipPath(
              clipper: SemiCircularClipper(boxWidth: availableWidth/(numItems+1), boxHeight: containerHeight-10),
              child: Container(
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  // border: Border.all(
                  //   // color: Colors.black, // Border color
                  //   width: 1.5, // Border width
                  // ),
                  // borderRadius: BorderRadius.circular(availableWidth/(numItems+1)/2),
                  color: ColorReturner().primary
                ),
                width: availableWidth*2,
                height: containerHeight,
              ),
            )
          ),
          AnimatedPositioned( // black outlining the bottom bar
            top: 2, // need to push it a bit down so that the path has enough room
            curve: Curves.easeInOutQuad,
            left: (availableWidth/(numItems+1))/(numItems+1) + availableWidth/(numItems+1)*(numItems+2)/(numItems+1)*_selectedIndex - availableWidth,
            duration: Duration(milliseconds: ((_previouslySelectedIndex-_selectedIndex).abs()+2)*150),
            child: CustomPaint(painter: CurvedBorderPainter(boxWidth: availableWidth/(numItems+1), boxHeight: containerHeight-10))
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  const Spacer(),
                  _buildNavItem(0, availableWidth),
                  const Spacer(),
                  _buildNavItem(1, availableWidth),
                  const Spacer(),
                  _buildNavItem(2, availableWidth),
                  const Spacer(),
                  _buildNavItem(3, availableWidth),
                  const Spacer(),
                  _buildNavItem(4, availableWidth),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildNavItem(final int index, final double availableWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _previouslySelectedIndex = _selectedIndex;
          _selectedIndex = index;
        });
        print(_selectedIndex);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: availableWidth/(numItems+1),
          child: Icon(
            _iconReturner(index, index==_selectedIndex),
            color: Colors.white,
            shadows: [
              globalShadow(index==_selectedIndex, color: Colors.black)
            ]
          ),
        ),
      ),
    );
  }

  IconData _iconReturner(final int index, final bool selected) {
    if(index==0) {
      return selected ? Icons.local_dining_sharp : Icons.local_dining_rounded;
    } else if(index==1) {
      return selected ? Icons.qr_code_scanner : Icons.qr_code;
    } else if(index==2) {
      return selected ? Icons.edit_note : Icons.edit;
    } else if(index==3) {
      return selected ? Icons.document_scanner : Icons.document_scanner_outlined;
    } else { // index==4
      return selected ? Icons.settings_applications_outlined : Icons.settings_applications;
    }
  }

  // label: 'Manage Diets',
  // label: 'Scan Barcode',
  // label: 'Manual Entry',
  // label: 'Scan Ingredients',
  // label: 'Settings',
}

// import 'package:flutter/material.dart';

class SemiCircularClipper extends CustomClipper<Path> {
  final double boxWidth;
  final double boxHeight;

  SemiCircularClipper({required this.boxWidth, required this.boxHeight});

  @override
  Path getClip(final Size size) {
    return getPath(boxHeight, boxWidth);
  }

  @override
  bool shouldReclip(final CustomClipper<Path> oldClipper) => false;
}

class CurvedBorderPainter extends CustomPainter {
  final double boxWidth;
  final double boxHeight;

  CurvedBorderPainter({required this.boxWidth, required this.boxHeight});

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Path path = getPath(boxHeight, boxWidth);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path getPath(final double boxHeight, final double boxWidth) {
  final Path path = Path();
  
  final double borderHeight = boxHeight *1/2;
  final double point1Height = borderHeight*2/5;
  final double halfWidth = boxWidth/2;
  final double point2Width = halfWidth*1/5;

  path.moveTo(0, boxHeight+10); // move to bottom left
  path.lineTo(0, boxHeight); // left edge of bar
  path.lineTo(boxWidth*(numItems+1)-halfWidth, boxHeight);

  path.cubicTo(
    boxWidth*(numItems+1)-point2Width, boxHeight, 
    boxWidth*(numItems+1), boxHeight-point1Height, 
    boxWidth*(numItems+1), borderHeight,
  );
  path.cubicTo(
    boxWidth*(numItems+1), point1Height, 
    boxWidth*(numItems+1)+point2Width, 0, 
    boxWidth*(numItems+1)+halfWidth, 0
  );
  path.cubicTo(
    boxWidth*(numItems+1)+2*halfWidth-point2Width, 0, 
    boxWidth*(numItems+1)+boxWidth, point1Height, 
    boxWidth*(numItems+1)+boxWidth, borderHeight,
  );
  path.cubicTo(
    boxWidth*(numItems+1)+boxWidth, boxHeight-point1Height, 
    boxWidth*(numItems+1)+point2Width+boxWidth, boxHeight,
    boxWidth*(numItems+1)+boxWidth+halfWidth, boxHeight
  );
  
  // Draw the rectangle at the bottom
  path.lineTo(boxWidth*(numItems+1)+boxWidth*(numItems+1), boxHeight);
  path.lineTo(boxWidth*(numItems+1)+boxWidth*(numItems+1), boxHeight+10);
  path.close();

  return path;
}