import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredImage extends StatelessWidget {
  const BlurredImage({
    Key? key,
    required this.imageBytes,
    required this.child,
  }) : super(key: key);
  final Uint8List imageBytes;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(imageBytes),
          opacity: 0.7,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: child,
      ),
    );
  }
}
