import 'package:flutter/material.dart';

class MoveMapGesture extends StatelessWidget {
  final Widget child;

  const MoveMapGesture({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(120),
      minScale: 0.01,
      maxScale: 2.0,
      child: child,
    );
  }
}
