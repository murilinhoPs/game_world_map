import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MapBorder extends StatelessWidget {
  const MapBorder({
    Key? key,
    this.width = 20.0,
    this.padding = const EdgeInsets.all(12.0),
    required this.child,
  }) : super(key: key);
  final Widget child;
  final double width;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 115, 37, 60),
          width: width,
        ),
      ),
      child: child,
    );
  }
}
