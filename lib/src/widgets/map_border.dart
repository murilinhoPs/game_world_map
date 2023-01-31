import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MapBorder extends StatelessWidget {
  const MapBorder({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 115, 37, 60),
          width: 20.0,
        ),
      ),
      child: child,
    );
  }
}
