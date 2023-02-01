import 'package:flutter/material.dart';

class MapBorder extends StatelessWidget {
  const MapBorder({
    Key? key,
    this.width = 20.0,
    this.padding = const EdgeInsets.all(12.0),
    this.radius = 0.0,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final double width;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 115, 37, 60),
          width: width,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            radius,
          ),
        ),
      ),
      child: child,
    );
  }
}
