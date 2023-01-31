import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'map_painter_controller.dart';
import 'widgets/location_info_dialog.dart';

class MapCanvas extends CustomPainter {
  final BuildContext context;
  final ui.Image image;
  final MapPainterController controller;
  const MapCanvas(
    this.context,
    this.image,
    this.controller,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);

    drawImage(myCanvas, size);
    drawCoordinate(myCanvas, size);
  }

  void drawImage(TouchyCanvas canvas, Size size) {
    final paint = Paint();

    canvas.drawImage(
      image,
      Offset.zero,
      paint,
      onTapDown: (details) => print('ImageTap: ${details.localPosition}'),
    );
  }

  void drawCoordinate(TouchyCanvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromARGB(148, 170, 68, 170)
      ..style = PaintingStyle.fill;

    for (var coordinate in controller.locations!) {
      if (coordinate.show) {
        canvas.drawCircle(
            Offset(
              coordinate.x,
              coordinate.y,
            ),
            50,
            paint1, onTapDown: (details) {
          print(
              'Tap ${coordinate.name} (${coordinate.id}): ${details.localPosition}');
          showAlertDialog(coordinate, context);
        });
      }
    }
  }

  @override
  bool shouldRepaint(MapCanvas oldDelegate) {
    return true;
  }
}
