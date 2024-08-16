import 'package:flutter/material.dart';

// This button shrinks when tapped

class LibraryButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const LibraryButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  LibraryButtonState createState() => LibraryButtonState();
}

class LibraryButtonState extends State<LibraryButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  // bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Change cursor to indicate clickable
      // onEnter: (final _) => setState(() => _isHovering = true),
      // onExit: (final _) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (final _) {
          _animationController.forward(); // Shrink on tap down
        },
        onTapUp: (final _) {
          _animationController.reverse(); // Return to original size
          widget.onTap(); // Call the provided onTap callback
        },
        onTapCancel: () {
          _animationController.reverse(); // Return to original size if the tap is canceled
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            // color: _isHovering ? Colors.blue.shade700 : Colors.blue, // Change color on hover
            color: const Color.fromARGB(85, 244, 67, 54),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}