import 'package:flutter/material.dart';

import 'map_canvas.dart';

class MapPainter extends StatefulWidget {
  const MapPainter({Key? key}) : super(key: key);

  @override
  State<MapPainter> createState() => _MapPainterState();
}

class _MapPainterState extends State<MapPainter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: MapCanvas(),
          child: Container(),
          // size: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}
