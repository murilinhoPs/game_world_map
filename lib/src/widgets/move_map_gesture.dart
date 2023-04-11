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
      boundaryMargin: const EdgeInsets.fromLTRB(240, 160, 240, 160),
      minScale: 0.01,
      maxScale: 2.8,
      child: child,
    );
  }
}
