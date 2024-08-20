import 'package:flutter/material.dart';

// This button shrinks when tapped

class LibraryButton extends StatefulWidget {
  final Widget Function(double animationValue) childBuilder;
  final VoidCallback onTap;

  const LibraryButton({
    super.key,
    required this.childBuilder,
    required this.onTap,
  });

  @override
  LibraryButtonState createState() => LibraryButtonState();
}

class LibraryButtonState extends State<LibraryButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

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
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return widget.childBuilder(_scaleAnimation.value);
            },
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
